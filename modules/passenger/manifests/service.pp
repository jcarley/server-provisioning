class passenger::service {
  exec { "reload-nginx":
    command     => "/usr/sbin/service nginx reload",
    refreshonly => true,
  }
}
