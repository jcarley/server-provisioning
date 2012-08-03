#!/usr/bin/env bash

apt-get -y update

# We are going to use git as our decision token
if [ ! $(which git) ]; then
  echo "Installing essential server packages."
  apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev libyaml-dev git-core python-software-properties
fi

if [ ! $(which ruby) ]; then
  echo "Install ruby 1.8.7 as the system ruby."
  apt-get install ruby ruby-dev
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
  gem install puppet --no-ri --no-rdoc
fi

