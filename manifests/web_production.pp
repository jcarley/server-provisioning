
class web::production {
  include nginx

  nginx::vhost { 'www.finishfirstsoftware.com':
    require => File['/home/deployer/apps'],
  }

  package { "imagemagick":
    ensure => 'present',
  }

  group { "admin":
    ensure => "present",
  }

  user { "deployer":
    ensure     => 'present',
    shell      => '/bin/zsh',
    groups     => ['admin'],
    home       => '/home/deployer',
    managehome => true,
  }

  file { "/home/deployer/apps":
    ensure  => directory,
    owner   => 'deployer',
    group   => 'deployer',
    require => User["deployer"],
  }

  class {'postgresql::server':
    version => '9.1',
  }

  postgresql::db { 'carleyfamily_production':
      owner    => 'carleyfamily',
      password => 'letmein123',
      require  => Class['postgresql::server'],
  }

  # rbenv::install { "deployer": }

  # rbenv::compile { "1.9.3-p194":
    # user    => 'deployer',
    # default => true,
  # }

  # class { "ufw": }

  # ufw::allow { "allow-ssh-from-all":
    # port => 22,
  # }

  # ufw::allow { "allow-http-from-all":
    # port => 80,
  # }
}
