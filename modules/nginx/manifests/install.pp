class nginx::install {

  exec { "nginx install":
    path => '/usr/bin:/usr/sbin:/bin',
    command => "export V=1.2.3 ;
      export prefix=/opt/nginx ;
      export etc=/usr/local/etc ;
      export var=/usr/local/var ;
      export upload_module=/tmp/upload_module ;
      export upload_progress_module=/tmp/upload_progress_module ;

      wget -O /tmp/nginx-$V.tar.gz http://nginx.org/download/nginx-$V.tar.gz ;
      wget -O $upload_module/nginx_upload_module.tar.gz http://www.grid.net.ru/nginx/download/nginx_upload_module-2.2.0.tar.gz ;
      wget -O $upload_progress_module/nginx_upload_progress_module.tar.gz https://github.com/downloads/masterzen/nginx-upload-progress-module/nginx_uploadprogress_module-0.9.0.tar.gz 
      cd /tmp && tar xzvf nginx-$V.tar.gz ;
      cd $upload_module && tar xzvf nginx_upload_module.tar.gz ;
      cd $upload_progress_module && tar xzvf nginx_upload_progress_module.tar.gz ;
      cd /tmp ;
      ./configure --prefix=$prefix --with-http_ssl_module --with-pcre --with-ipv6 --conf-path=$etc/nginx/nginx.conf --pid-path=$var/run/nginx.pid --lock-path=$var/nginx/nginx.lock --add-module=$upload_module --add-module=$upload_progress_module
      make ;
      make install ;",
    creates  => '/opt/nginx',
    require => [
      Class['nginx::dependencies'],
    ],
  }

  # exec { "reload nginx":
    # command => "/usr/sbin/service nginx reload",
    # require => Package["nginx"],
    # refreshonly => true,
  # }

  # file { "/etc/nginx/nginx.conf":
    # source => "puppet:///modules/nginx/nginx.conf",
    # notify => Exec["reload nginx"],
    # require => Package["nginx"],
  # }
}
