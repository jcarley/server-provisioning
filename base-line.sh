#!/usr/bin/env bash

sudo apt-get update

if [ ! $(which git) ]; then
  sudo apt-get install -y git-core
fi

if [ ! $(which add-apt-repository) ]; then
  sudo apt-get install -y python-software-properties
fi

#if [ ! $(cat /etc/group | cut -d: -f1 | grep "^admin$") ]; then
  #sudo groupadd admin
#fi

#if [ ! $( groups | grep "\sadmin\s") ]; then
  #sudo useradd -G admin deployer
#fi


