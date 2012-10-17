class puma::install {
  $ruby_home = ""

  exec { install_puma:
    command => 'ruby gem install puma',
    path    => "${ruby_home}/bin:${path}",
    unless  => "which puma",
  }

  file { '/etc/init.d/puma':
    alias   => install_puma_init_services,
    ensure  => present,
    source  => 'puppet:///modules/puma/puma',
    owner   => 'root',
    group   => 'root',
    mode    => 'ug+x',
    require => Exec[install_puma],
  }

  exec { startup_script:
    command => 'update-rc.d -f puma defaults',
    creates => [ '/etc/rc0.d/K20puma',
                 '/etc/rc1.d/K20puma',
                 '/etc/rc2.d/K20puma',
                 '/etc/rc3.d/K20puma',
                 '/etc/rc4.d/K20puma',
                 '/etc/rc5.d/K20puma',
                 '/etc/rc6.d/K20puma' ],
    require => File[install_puma_init_services],
  }

  file { '/usr/local/bin/run-puma':
    ensure  => present,
    source  => 'puppet:///modules/puma/run-puma',
    owner   => 'root',
    group   => 'root',
    mode    => 'ug+x',
    require => Exec[install_puma],
  }

  file { '/etc/puma.conf':
    ensure  => present,
    require => Exec[install_puma],
  }
}
