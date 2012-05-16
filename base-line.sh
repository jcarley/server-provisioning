#!/usr/bin/env bash

if [ $(id -u) -eq 0 ]; then

  # this will always be called.
  #sudo apt-get update

  if [ ! $(which git) ]; then
    sudo apt-get install -y git-core
  else
    echo "Git already installed."
  fi

  if [ ! $(which add-apt-repository) ]; then
    sudo apt-get install -y python-software-properties
  else
    echo "Python software properties already installed."
  fi
  
  if [ ! $(cat /etc/group | cut -d: -f1 | grep "^admin$") ]; then
    sudo groupadd admin
  else
    echo "Group admin exists."
  fi

  egrep "^puppet" /etc/passwd > /dev/null
  if [ $? -ne 0 ]; then
    # user does not exist, so add
    sudo useradd --comment "Puppet" --no-create-home --system --shell /bin/false puppet
  else
    echo "User puppet exists."
  fi

  egrep "^deployer" /etc/passwd > /dev/null
  if [ $? -ne 0 ]; then
    # user does not exist, so add
    sudo useradd -m --comment "Deployer" --shell /bin/bash --groups admin deployer
    sudo passwd deployer
  else
    echo "User deployer already exists."
  fi

  # change to deployer user
  echo "Switching to deployer user."
  su deployer -c ./install-rbenv.sh

fi


