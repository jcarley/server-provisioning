class nginx::service {

  exec { "start nginx":
    command => "/usr/sbin/service nginx start",
    require => Exec["install script"],
    refreshonly => true,
  }

  exec { "reload nginx":
    command => "/usr/sbin/service nginx reload",
    require => Exec["install script"],
    refreshonly => true,
  }

}
