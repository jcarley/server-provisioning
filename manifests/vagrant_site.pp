Exec {
  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
}

class base {
  include ssh

  exec { "apt-update":
    command => "/usr/bin/apt-get update",
  }
  Exec["apt-update"] -> Package <| |>

  group { "puppet":
    ensure  => "present",
    require => Exec["apt-update"],
  }
}

node 'web01' {
  include base
  include apache

  apache::vhost { 'www.example.com':
    port          => 80,
    docroot       => '/var/www/www.example.com',
    ssl           => false,
    priority      => 10,
    serveraliases => 'home.example.com',
  }

  class {'postgresql::server':
    version => '9.1',
  }

  postgresql::db { 'carleyfamily_production':
      owner    => 'carleyfamily',
      password => 'letmein123',
      require  => Class['postgresql::server'],
  }
}


