class puma::init(
  $run_as_user,
  $rails_env,
) {

  file { '/etc/init/puma-manager.conf':
    alias  => 'install_puma_service_manager',
    ensure => present,
    source => "puppet:///modules/puma/puma-manager.conf",
    owner  => 'root',
    group  => 'root',
  } ->

  file { '/etc/init/puma.conf':
    alias   => 'install_puma_service_config',
    ensure  => present,
    content => template('puma/puma.conf.erb'),
    owner   => 'root',
    group   => 'root',
  } ->

  file { '/etc/puma.conf':
    ensure => present,
  }

}
