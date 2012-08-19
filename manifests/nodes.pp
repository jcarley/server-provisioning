
import base_node.pp

node 'web01' {
  include base
  include nginx

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

  nginx::vhost { 'www.finishfirstsoftware.com':
    require => File['/home/deployer/apps'],
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
