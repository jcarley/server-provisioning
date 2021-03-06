#!/usr/bin/env bash

apt-get -y update

# We are going to use git as our decision token
if [ ! $(which git) ]; then
  echo "Installing essential server packages."
  apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev libyaml-dev git-core python-software-properties

  add-apt-repository ppa:nginx/stable
  add-apt-repository ppa:pitti/postgresql
  add-apt-repository ppa:chris-lea/node.js

  apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
  echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" | tee -a /etc/apt/sources.list.d/10gen.list

  apt-get -y update
else
  echo "Server essentials already installed."
fi

if [ ! $(which ruby) ]; then
  echo "Install ruby 1.8.7 as the system ruby."
  apt-get -y install ruby ruby-dev rubygems
else
  echo "Ruby is all ready installed."
fi

# add the puppet user
egrep "^puppet" /etc/passwd > /dev/null
if [ $? -ne 0 ]; then
  # user does not exist, so add
  sudo useradd --comment "Puppet" --no-create-home --system --shell /bin/false puppet
else
  echo "User puppet already exists."
fi

if [ ! -d /etc/puppet ]; then
  echo "Creating /etc/puppet folder."

  cd /etc
  git clone git://github.com/jcarley/server-provisioning.git puppet
else
  echo "Folder /etc/puppet already exists."
fi

if [ ! $(which puppet) ]; then
  echo "Installing puppet gem."
  gem install puppet --no-ri --no-rdoc
else
  echo "Puppet gem already installed."
fi

