Exec {
  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
}

group { "admin":
    ensure => "present",
}

user { "deployer":
  ensure     => "present",
  managehome => true,
  group      => "admin",
}

include nginx

node default {

  class { "rbenv":
    user     => 'deployer',
    group    => 'admin',
    home_dir => '/home/deployer',
    compile  => true,
    version  => '1.9.3-p194',
  }

  rbenv::install { "deployer",
    home => '/home/deployer',
  }

  rbenv::complile { "1.9.3-p194",
    user => 'deployer',
    home => '/home/deployer',
  }

  class { "postgresql::server": }

  postgresql::db { "carleyfamily_production":
    owner    => "carleyfamily",
    password => "letmein123ABC",
  }

  class { "ufw": }

  ufw::allow { "allow-ssh-from-all":
    port => 22,
  }

  ufw::allow { "allow-http-from-all":
    port => 80,
  }
}
