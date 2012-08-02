Exec {
  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
}

include nginx

node default {
  nginx::site { "finishfirstsoftware.com": }

  class { "rbenv":
    user     => 'deployer',
    group    => 'admin',
    home_dir => '/home/deployer',
    compile  => true,
    version  => '1.9.3-p194',
  }

  class { "postgresql::server": }

  postgresql::db { "carleyfamily_production":
    owner    => "carleyfamily",
    password => "letmein123ABC",
  }
}
