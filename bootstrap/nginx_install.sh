#!/bin/bash

V=1.2.3
prefix=/opt/nginx
etc=/usr/local/etc
var=/usr/local/var

upload_module_name=nginx_upload_module.tar.gz
upload_module_path=/tmp/upload_module
upload_module=$upload_module_path/$upload_module_name

upload_progress_module_name=nginx_upload_progress_module.tar.gz
upload_progress_module_path=/tmp/upload_progress_module
upload_progress_module=$upload_progress_module_path/$upload_progress_module_name

wget -O /tmp/nginx-$V.tar.gz http://nginx.org/download/nginx-$V.tar.gz
wget -O $upload_module http://www.grid.net.ru/nginx/download/nginx_upload_module-2.2.0.tar.gz
wget -O $upload_progress_module https://github.com/downloads/masterzen/nginx-upload-progress-module/nginx_uploadprogress_module-0.9.0.tar.gz
cd /tmp && tar xzvf nginx-$V.tar.gz
cd $upload_module_path && tar xzvf nginx_upload_module.tar.gz
cd $upload_progress_module_path && tar xzvf nginx_upload_progress_module.tar.gz
cd /tmp
./configure --prefix=$prefix --with-http_ssl_module --with-pcre --with-ipv6 --conf-path=$etc/nginx/nginx.conf --pid-path=$var/run/nginx.pid --lock-path=$var/nginx/nginx.lock --add-module=$upload_module_path --add-module=$upload_progress_module_path
make
make install
