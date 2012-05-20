#!/usr/bin/env bash
apt-get -y update
apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev libyaml-dev git-core python-software-properties

#cd /tmp
#wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p194.tar.gz 
#tar -xvzf ruby-1.9.3-p194.tar.gz
#cd ruby-1.9.3-p194/
#./configure --prefix=/usr/local
#make
#make install

add-apt-repository ppa:nginx/stable
add-apt-repository ppa:pitti/postgresql
add-apt-repository ppa:chris-lea/node.js
apt-get -y update

# install nginx
apt-get -y install nginx

# install postgresql
apt-get install postgresql libpq-dev

# install postfix for sending emails
apt-get install postfix

# install node.js
apt-get -y install nodejs

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

# install rbenv and ruby for deployer user 
echo "Installing rbenv for deployer"
su deployer -c "curl -L https://raw.github.com/jcarley/server-provisioning/master/bootstrap/install-rbenv.sh | bash"

service nginx start
