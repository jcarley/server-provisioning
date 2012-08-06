Exec {
  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
}

node default {

  include nginx
  include user_homedir

  group { "admin":
    ensure => "present",
  }

  user_homedir { "deployer":
    group  => "admin",
    shell  => "/bin/bash",
    ensure => present,
  }

  # rbenv::install { "deployer": }

  # rbenv::compile { "1.9.3-p194":
    # user    => 'deployer',
    # default => true,
  # }

  # class { "postgresql::server": }

  # postgresql::db { "carleyfamily_production":
    # owner    => "carleyfamily",
    # password => "letmein123ABC",
  # }

  class { "ufw": }

  ufw::allow { "allow-ssh-from-all":
    port => 22,
  }

  ufw::allow { "allow-http-from-all":
    port => 80,
  }
}
