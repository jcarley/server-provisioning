define passenger::app(
  $passenger_version = "4.0.2",
  $nginx_version     = '1.4.1',
  $ruby_home,
  $gem_path,
  $sitedomain,
  $runstage,
) {

  include passenger::service

  file { "/etc/nginx/conf/sites-available/${application_name}.conf":
    alias   => 'site-available',
    content => template("rails/app.conf.erb"),
  }

  file { "/etc/nginx/conf/sites-enabled/${application_name}.conf":
    alias   => 'site-enabled',
    ensure  => link,
    target  => "/etc/nginx/conf/sites-available/${application_name}.conf",
    require => File["site-available"],
    notify  => Exec["reload-nginx"],
  }

  file { "/etc/nginx/conf/includes/${application_name}.conf":
    source   => [ "puppet:///modules/rails/${application_name}.conf", "puppet:///modules/rails/empty.conf" ],
    notify   => Exec["reload-nginx"],
  }

  file { [ "/var/www",
  "/var/www/${application_name}",
  "/var/www/${application_name}/releases",
  "/var/www/${application_name}/shared",
  "/var/www/${application_name}/shared/config",
  "/var/www/${application_name}/shared/log",
  "/var/www/${application_name}/shared/system" ]:
    ensure => directory,
    mode   => 775,
    owner  => "www-data",
    group  => "www-data",
  }

  }
}

