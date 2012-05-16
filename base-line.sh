#!/usr/bin/env bash

if [ $(id -u) -eq 0 ]; then

  # this will always be called.
  sudo apt-get update

  if [ ! $(which git) ]; then
    sudo apt-get install -y git-core
  fi

  if [ ! $(which add-apt-repository) ]; then
    sudo apt-get install -y python-software-properties
  fi
  
  if [ ! $(cat /etc/group | cut -d: -f1 | grep "^admin$") ]; then
    sudo groupadd admin
  fi

  egrep "^puppet" /etc/passwd > /dev/null
  if [ $? -ne 0 ]; then
    # user does not exist, so add
    sudo useradd --comment "Puppet" --no-create-home --system --shell /bin/false puppet
  fi

  egrep "^deployer" /etc/passwd > /dev/null
  if [ $? -ne 0 ]; then
    # user does not exist, so add
    sudo useradd -m --comment "Deployer" --shell /bin/bash --groups admin deployer
    sudo passwd deployer
  fi

  #if [ ! $( groups | grep "\sadmin\s") ]; then
    #sudo useradd -G admin deployer
  #fi

fi





