class web::production {

  group { "admin":
    ensure => "present",
  }

  user { "deployer":
    ensure     => 'present',
    shell      => '/bin/bash',
    groups     => ['admin'],
    home       => '/home/deployer',
    managehome => true,
  }

  file { "/home/deployer/apps":
    alias   => 'apps',
    ensure  => directory,
    owner   => 'deployer',
    group   => 'deployer',
    require => User["deployer"],
  }


}
