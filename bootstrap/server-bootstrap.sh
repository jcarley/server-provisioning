#!/usr/bin/env bash
apt-get -y update
apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev libyaml-dev git-core python-software-properties

cd /tmp
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p194.tar.gz 
tar -xvzf ruby-1.9.3-p194.tar.gz
cd ruby-1.9.3-p194/
./configure --prefix=/usr/local
make
make install

