#!/bin/bash

export CC=gcc-4.4

V=1.2.3
prefix=/opt/nginx
etc=/usr/local/etc
var=/usr/local/var

upload_module_name=nginx_upload_module-2.2.0.tar.gz
upload_module_path=/tmp/nginx_upload_module-2.2.0

upload_progress_module_name=nginx_uploadprogress_module-0.9.0.tar.gz
upload_progress_module_path=/tmp/masterzen-nginx-upload-progress-module-a788dea

sudo mkdir -p $etc/nginx
sudo mkdir -p $var/nginx
sudo mkdir -p $var/run

cd /tmp

if [ ! -d /tmp/nginx-$V ]; then
  wget http://nginx.org/download/nginx-$V.tar.gz
  tar -xzvf nginx-$V.tar.gz
fi

if [ ! -d $upload_module_path ]; then
  cd /tmp
  wget http://www.grid.net.ru/nginx/download/$upload_module_name
  tar -xzvf $upload_module_name
fi

if [ ! -d $upload_progress_module_path ]; then
  cd /tmp
  wget https://github.com/downloads/masterzen/nginx-upload-progress-module/$upload_progress_module_name
  tar -xzvf $upload_progress_module_name
fi

cd /tmp/nginx-$V

# TODO: Add flv support
./configure --prefix=$prefix --with-http_ssl_module --with-http_flv_module --with-http_gzip_static_module --with-pcre --with-ipv6 --conf-path=$etc/nginx/nginx.conf --pid-path=$var/run/nginx.pid --lock-path=$var/nginx/nginx.lock --add-module=$upload_module_path --add-module=$upload_progress_module_path
make
sudo make install


# TODO:  Clean up tmp
