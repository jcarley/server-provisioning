
import "base_node"

node 'web01' {
  include base
  include nginx

  nginx::vhost { 'www.finishfirstsoftware.com':
    require => File['/home/deployer/apps'],
  }

  package { "imagemagick":
    ensure => 'present',
  }

  user { "deployer":
    ensure     => 'present',
    shell      => '/bin/zsh',
    groups     => ['adm', 'admin'],
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

}

node 'web02' {
  include base
  include apache


  # group { "deployer":
    # ensure => 'present',
  # }

  user { "deployer":
    ensure     => 'present',
    shell      => '/bin/zsh',
    groups     => ['adm', 'admin'],
    home       => '/home/deployer',
    managehome => true,
  }

  file { "/home/deployer/apps":
    ensure  => directory,
    owner   => 'deployer',
    group   => 'deployer',
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

}
