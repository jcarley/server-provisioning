import 'server_base'
import 'web_production'

node ffs-vpc-web01 {
  include server::base

  $run_as_user = "deployer"

  package { 'vim':
    ensure => present,
  }

  class { "nodejs":
    version => 'v0.10.5',
  }

  group { "admin":
    ensure => "present",
  }

  user { $run_as_user:
    ensure     => 'present',
    shell      => '/bin/bash',
    groups     => ['admin'],
    home       => "/home/${run_as_user}",
    managehome => true,
    require    => Group["admin"],
  }

  file { "/home/${run_as_user}":
    ensure  => directory,
    owner   => $run_as_user,
    group   => $run_as_user,
    require => User["${run_as_user}"],
  }

  file { "/home/${run_as_user}/apps":
    ensure  => directory,
    owner   => "${run_as_user}",
    group   => "${run_as_user}",
    require => User["${run_as_user}"],
  }

  ssh::user { $run_as_user:
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEAx/t0A139x5hD/k/mrAvcsEstchQ6NiEce4Jt5ZvyUBXEjgMUB2A9BJxwlbORLbRp+PBk37n0lEIt3hYIDbrMRQzB6mFYtlEFptmGBxlCyfgzNawwG9TotJKYro8t7w9C1nH7l2ZVDS7NwfJly+gwDoUg/6A/yE38mOhQkDY8RweFeaVE8UaOe0VP3ilyCcdMdcBW//j+6juuRhbZXkD1sDUN866I9q5ovJBDf9sBTvmWD35irb4svW9kYmVdcXj3a8XHOGN8L+bWgzkyxG3x3kqonq6sBF8q0/awVVE2c8Or9oBmeBzcw3pwwSk3ZX/ms3zlGpnBMWplFOnBrz8bdw==",
    require => [ User[$run_as_user], File["/home/${run_as_user}"] ],
  }

  rbenv::install { "${run_as_user}":
    group   => "${run_as_user}",
    home    => "/home/${run_as_user}",
    rc      => ".bashrc",
    require => User["${run_as_user}"],
  }

  rbenv::compile { "2.0.0-p0":
    user    => "${run_as_user}",
    home    => "/home/${run_as_user}",
    global  => true,
    require => Rbenv::Install["${run_as_user}"],
  }

  class { "mongodb":
    init         => 'upstart',
    enable_10gen => true,
  }

  class { "ufw": }

  ufw::allow { "allow-ssh-from-all":
    port => 22,
  }

  ufw::allow { "allow-http-from-all":
    port => 80,
  }
}

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

