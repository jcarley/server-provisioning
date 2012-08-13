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
  }

}

node 'web01' {
  include base
  include apache

  user { "deployer":
    ensure     => 'present',
    shell      => '/bin/bash',
    groups     => ['adm', 'admin'],
    home       => '/home/deployer',
    managehome => true,
  }

  file { "/home/deployer/apps":
    ensure => directory,
    require => User["deployer"],
  }

  apache::vhost { 'www.finishfirstsoftware.com':
    port          => 80,
    docroot       => '/home/deployer/apps/www.finishfirstsoftware.com',
    ssl           => false,
    priority      => 10,
    serveraliases => 'home.finishfirstsoftware.com',
    require       => File ["/home/deployer/apps"],
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


