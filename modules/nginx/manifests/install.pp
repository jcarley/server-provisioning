class nginx::install {

  exec { "nginx install":
    path => '/usr/bin:/usr/sbin:/bin',
    command => "",
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
