
class puma::install($ruby_home = '') {

  exec { "${ruby_home} gem install puma":
    command => "${ruby_home}/bin/gem install puma",
    path    => ["${ruby_home}/bin", $path],
    creates => "${ruby_home}/bin/puma",
    user    => 'root',
    group   => 'root',
  }

  file { '/etc/init.d/puma-manager.conf':
    alias   => install_puma_service_manager,
    ensure  => present,
    source  => "puppet:///modules/puma/puma-manager.conf",
    owner   => 'root',
    group   => 'root',
    require => Exec["${ruby_home} gem install puma"],
  }

  file { '/etc/init.d/puma.conf':
    alias   => install_puma_service_config,
    ensure  => present,
    source  => "puppet:///modules/puma/puma.conf",
    owner   => 'root',
    group   => 'root',
    require => Exec["${ruby_home} gem install puma"],
  }

  file { '/etc/puma.conf':
    ensure  => present,
    require => Exec["${ruby_home} gem install puma"],
  }

}
