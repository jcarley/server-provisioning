class nginx::install {

  exec { "nginx install":
    path => '/usr/bin:/usr/sbin:/bin',
    command => "
      cd /tmp ;
      mkdir nginx && cd nginx ;
      wget http://nginx.org/download/nginx-1.2.3.tar.gz ;
      tar zxf nginx-1.2.3.tar.gz ;





    ",
    creates  => '',
    requires => [
      Class['nginx::dependencies'],
    ],
  }

  exec { "reload nginx":
    command => "/usr/sbin/service nginx reload",
    require => Package["nginx"],
    refreshonly => true,
  }

  file { "/etc/nginx/nginx.conf":
    source => "puppet:///modules/nginx/nginx.conf",
    notify => Exec["reload nginx"],
    require => Package["nginx"],
  }
}
