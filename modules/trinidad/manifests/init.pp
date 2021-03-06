class trinidad($jruby_home = "/opt/jruby", $trinidad_home = "/opt/trinidad", $user = 'root') {

  if ! defined( Package["openjdk-7-jdk"] ) {
    package { "openjdk-7-jdk":
      ensure => present,
    }
  }

  if ! defined( Package["jsvc"] ) {
    package { "jsvc":
      ensure => present,
    }
  }

  if ! defined( File[$jruby_home] ) {
    file { $jruby_home:
      ensure => directory
    }
  }

  file { $trinidad_home:
    ensure => directory,
  }

  exec { install_trinidad:
    command => "jruby -S gem install trinidad -v 1.3.4",
    path    => "${jruby_home}/bin:${path}",
    creates => "${jruby_home}/bin/trinidad",
    require => File[$jruby_home],
  }

  exec { install_trinidad_init_services:
    command => "jruby -S gem install trinidad_init_services -v 1.1.3",
    path    => "${jruby_home}/bin:${path}",
    creates => "${jruby_home}/bin/trinidad_init_service",
    require => [Package[jsvc], Exec[install_trinidad], File[$jruby_home] ],
  }

  file { "${trinidad_home}/trinidad_config.yml":
    content => template("trinidad/trinidad_config.yml.erb"),
    require => Exec[install_trinidad_init_services],
  }

  exec { trinidad_init_service:
    command => "jruby -S trinidad_init_service ${trinidad_home}/trinidad_config.yml",
    path    => "${jruby_home}/bin:${path}",
    creates => "/etc/init.d/trinidad",
    require => File["${trinidad_home}/trinidad_config.yml", $jruby_home],
  }

  file { "${trinidad_home}/shared":
    owner   => $user,
    ensure  => directory,
    recurse => true,
    require => Exec[trinidad_init_service],
  }

  file { "/etc/init.d/trinidad":
    owner   => $user,
    require => Exec[trinidad_init_service],
  }

}
