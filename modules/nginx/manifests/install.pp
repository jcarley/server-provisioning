class nginx::install {

  exec { "nginx install":
    path => '/usr/bin:/usr/sbin:/bin',
    command => "~/share/bootstrap/nginx_install.sh",
    creates  => '/opt/nginx',
    require => [
      Class['nginx::dependencies'],
    ],
  }

  # file { "/usr/local/etc/nginx/nginx.conf":
    # source  => template("nginx.conf.erb"),
    # notify  => Exec["reload nginx"],
    # require => Package["nginx"],
  # }

  # exec { "reload nginx":
    # command => "/usr/sbin/service nginx reload",
    # require => Package["nginx"],
    # refreshonly => true,
  # }

}
