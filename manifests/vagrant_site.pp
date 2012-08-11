Exec {
  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
}

class base {
  include sudo, ssh
}

node default {
  include base

  group { "puppet":
    ensure => "present",
  }

  exec { "apt-update":
    command => "/usr/bin/apt-get update",
    require => Group[puppet]
  }
  Exec["apt-update"] -> Package <| |>

}

node 'web01' {

  class {'postgresql::server':
    version => '9.1',
  }

  postgresql::db { 'carleyfamily_production':
      owner    => 'carleyfamily',
      password => 'letmein123',
      require  => Class['postgresql::server'],
  }
}


