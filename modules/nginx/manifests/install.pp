class nginx::install {
  include nginx::service

  group { 'www-data':
    ensure => 'present'
  }

  user { 'www-data':
    ensure => 'present',
    groups => ['www-data'],
  }

  exec { 'curl -L https://raw.github.com/jcarley/server-provisioning/master/bootstrap/nginx_install.sh | bash':
    path    => '/usr/bin:/usr/sbin:/bin',
    alias   => 'nginx install',
    creates => '/opt/nginx',
    require => [
      Class['nginx::dependencies'],
    ],
  }

  file { '/usr/local/etc/nginx/nginx.conf':
    content  => template('nginx/nginx.conf.erb'),
    require => Exec['nginx install'],
  }

  file { '/etc/init.d/nginx':
    ensure  => present,
    source  => 'puppet:///modules/nginx/nginx',
    owner   => 'root',
    group   => 'root',
    mode    => 0755,
    require => Exec['nginx install'],
  }

  exec { 'update-rc.d -f nginx defaults':
    alias   => 'install script',
    creates => [ '/etc/rc0.d/K20nginx',
                 '/etc/rc1.d/K20nginx',
                 '/etc/rc2.d/K20nginx',
                 '/etc/rc3.d/K20nginx',
                 '/etc/rc4.d/K20nginx',
                 '/etc/rc5.d/K20nginx',
                 '/etc/rc6.d/K20nginx' ],
    require => File['/etc/init.d/nginx'],
    notify  => Exec['start nginx'],
  }

  file { [ '/usr/local/etc/nginx/sites-available',
           '/usr/local/etc/nginx/sites-enabled' ]:
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
    require => Exec['nginx install'],
  }


}
