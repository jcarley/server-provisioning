Exec {
  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
}

include nginx
include postgres

node default {
  nginx::site { "finishfirstsoftware.com": }

  class { "rbenv":
    user => 'deployer',
    group => 'admin',
    home_dir => '/home/deployer',
    compile => true,
    version => '1.9.3-p194',
  }

  postgres::role { "carleyfamily":
    ensure   => present,
    password => "letmein123ABC"
  }

  postgres::database { "carleyfamily_production":
    ensure => present,
    owner  => "carleyfamily",
  }

}
