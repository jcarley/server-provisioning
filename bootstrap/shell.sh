#!/usr/bin/env bash

apt-get -y update

# We are going to use git as our decision token
if [ ! $(which git) ]; then
  echo "Installing essential server packages."
  apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev libyaml-dev git-core python-software-properties

  add-apt-repository ppa:nginx/stable
  add-apt-repository ppa:pitti/postgresql
  add-apt-repository ppa:chris-lea/node.js
  apt-get -y update
else
  echo "Server essentials already installed."
fi

# add the puppet user
egrep "^puppet" /etc/passwd > /dev/null
if [ $? -ne 0 ]; then
  # user does not exist, so add
  sudo useradd --comment "Puppet" --no-create-home --system --shell /bin/false puppet
else
  echo "User puppet already exists."
fi
