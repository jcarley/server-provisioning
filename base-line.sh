#!/usr/bin/env bash

if [ $(id -u) -eq 0 ]; then

  # this will always be called.
  sudo apt-get update

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
  sudo su deployer

  RBENV_ROOT="$HOME/.rbenv"

  echo "Installing rbenv at $RBENV_ROOT"

  if [ ! -d "$RBENV_ROOT" ] ; then

    echo "changing directory to $HOME"
    cd $HOME

    # check for, and install rbenv
    #curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash

    # take a backup of .bashrc
    echo "Making a backup of the .bashrc"
    cp .bashrc .bashrc.original

    # insert lines at top of .bashrc
    echo "Adding rbenv to the load path"
    echo "if [ -d \$HOME/.rbenv ]; then" >> bashrc.tmp
    echo "  export PATH=\"\$HOME/.rbenv/bin:\$PATH\"" >> bashrc.tmp
    echo "  eval \"\$(rbenv init -)\"" >> bashrc.tmp
    echo "fi" >> bashrc.tmp
    cat .bashrc >> .bashrc.tmp
    mv .bashrc.tmp .bashrc

    # source .bashrc
    #source ~/.bashrc
  
    # install some server essentials
    #rbenv bootstrap-ubuntu-11-10

    # install ruby
    #rbenv install 1.9.3-p125

    # set 1.9.3 as our global ruby
    #rbenv global 1.9.3-p125

    # install gems
    #rbenv bootstrap

    # install bundler
    #gem install bundler --no-ri --no-rdoc
  fi

fi


