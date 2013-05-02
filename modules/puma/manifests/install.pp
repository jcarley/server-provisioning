define puma::install($ruby_home = '') {

  if ! defined( Class['puma::params'] ) {
    require puma::params
  }

  $puma_service_file = $puma::params::puma_service_file

  exec { "${ruby_home} gem install puma":
    command => "${ruby_home}/bin/gem install puma",
    path    => "${ruby_home}/bin:${path}",
    creates => "${ruby_home}/bin/puma",
    user    => 'root',
    group   => 'root',
  }

  file { '/etc/init.d/puma':
    alias   => install_puma_init_services,
    ensure  => present,
    source  => "puppet:///modules/puma/${$puma_service_file}",
    owner   => 'root',
    group   => 'root',
    mode    => 'ug+x',
    require => Exec["${ruby_home} gem install puma"],
  }

  exec { startup_script:
    command => $puma::params::startup_script_command,
    creates => [ "/etc/rc0.d/${puma::params::startup_script_resource}",
                 "/etc/rc1.d/${puma::params::startup_script_resource}",
                 "/etc/rc2.d/${puma::params::startup_script_resource}",
                 "/etc/rc3.d/${puma::params::startup_script_resource}",
                 "/etc/rc4.d/${puma::params::startup_script_resource}",
                 "/etc/rc5.d/${puma::params::startup_script_resource}",
                 "/etc/rc6.d/${puma::params::startup_script_resource}" ],
    path    => $path,
    require => File[install_puma_init_services],
  }

  file { '/usr/local/bin/run-puma':
    ensure  => present,
    source  => 'puppet:///modules/puma/run-puma',
    owner   => 'root',
    group   => 'root',
    mode    => 'a+xr,u+rw',
    require => Exec["${ruby_home} gem install puma"],
  }

  file { '/etc/puma.conf':
    ensure  => present,
    require => Exec["${ruby_home} gem install puma"],
  }
}
