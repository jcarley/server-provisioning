#!/usr/bin/env bash

apt-get -y update

# We are going to use git as our decision token
if [ ! $(which git) ]; then
  apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev libyaml-dev git-core python-software-properties
fi

if [ ! $(which ruby) ]; then
  #echo "Install ruby 1.9.3 from source as the system ruby"

  #cd /tmp
  #wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p194.tar.gz
  #tar -xvzf ruby-1.9.3-p194.tar.gz
  #cd ruby-1.9.3-p194/
  #./configure --prefix=/usr/local
  #make
  #make install

  echo "Install ruby 1.8.7 as the system ruby"
  sudo apt-get install ruby ruby-dev
fi

# add the puppet user
egrep "^puppet" /etc/passwd > /dev/null
if [ $? -ne 0 ]; then
  # user does not exist, so add
  sudo useradd --comment "Puppet" --no-create-home --system --shell /bin/false puppet
else
  echo "User puppet already exists."
fi

# add the admin group
if [ ! $(cat /etc/group | cut -d: -f1 | grep "^admin$") ]; then
  sudo groupadd admin
else
  echo "Group admin exists."
fi

# add the deployer user
egrep "^deployer" /etc/passwd > /dev/null
if [ $? -ne 0 ]; then
  # user does not exist, so add
  sudo useradd -m --comment "Deployer" --shell /bin/bash --groups admin deployer
  sudo passwd deployer
else
  echo "User deployer already exists."
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
