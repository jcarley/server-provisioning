class puma::install($ruby_home = '') {

  file { '/etc/init/puma-manager.conf':
    alias   => install_puma_service_manager,
    ensure  => present,
    source  => "puppet:///modules/puma/puma-manager.conf",
    owner   => 'root',
    group   => 'root',
  }

  file { '/etc/init/puma.conf':
    alias   => install_puma_service_config,
    ensure  => present,
    source  => "puppet:///modules/puma/puma.conf",
    owner   => 'root',
    group   => 'root',
  }

  file { '/etc/puma.conf':
    ensure  => present,
  }

}
