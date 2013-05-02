import 'server_base'
import 'web_production'

node moshpitvm {
  include server::base
  include redis

  package { 'build-essential':
    ensure => installed }
  package { 'openssl':
    ensure => installed }

  package { "openjdk-7-jdk":
    ensure => present,
  }

  package { "ant":
    ensure  => present,
    require => Package["openjdk-7-jdk"]
  }

  ruby::install { 'jruby-1.7.0':
    current => true,
    require => [ Package['openjdk-7-jdk'], Package['ant'] ],
  }

  class { 'trinidad':
    jruby_home => '/opt/rubies/current',
    require    => [ Ruby::Install['jruby-1.7.0'], Package['openjdk-7-jdk'] ]
  }

}

# web server setup for vagrant
node web01 {
  include server::base
  include jruby
  include puma
  # include web::production
  # include nginx

  package { 'vim':
    ensure => present,
  }

  file { ['/home/vagrant/apps',
          '/home/vagrant/apps/uploader' ]:
    ensure => directory,
    owner  => 'vagrant',
    group  => 'vagrant',
    before => Puma::App[install_app],
  }

  puma::app { install_app:
    app_path => '/home/vagrant/apps/uploader',
    user     => 'vagrant',
  }

  # nginx::vhost { 'www.finishfirstsoftware.com':
    # require => File['/home/deployer/apps'],
  # }
}

# web server setup for linode server
node 'localhost.members.linode.com' {
  include server::base
  include web::production
  include nginx

  package { "imagemagick":
    ensure => 'present',
  }

  package { "mongodb-10gen":
    ensure => 'present',
  }

  package { "nodejs":
    ensure => 'present',
  }

  class { "ufw": }

  ufw::allow { "allow-ssh-from-all":
    port => 22,
  }

  ufw::allow { "allow-http-from-all":
    port => 80,
  }
}

node web02 {
  include server::base
  include apache

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

  apache::vhost { 'www.example.com':
    port          => 80,
    docroot       => '/home/deployer/apps/www.example.com',
    ssl           => false,
    priority      => 10,
    serveraliases => 'home.example.com',
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

