define passenger::app(
  $sitedomain
) {

  include passenger::service

  file { "/etc/nginx/conf/sites-available/${name}.conf":
    alias   => 'site-available',
    content => template("passenger/app.conf.erb"),
  }

  file { "/etc/nginx/conf/sites-enabled/${name}.conf":
    alias   => 'site-enabled',
    ensure  => link,
    target  => "/etc/nginx/conf/sites-available/${name}.conf",
    require => File["site-available"],
    notify  => Exec["reload-nginx"],
  }

  file { "/etc/nginx/conf/includes/${name}.conf":
    source   => [ "puppet:///modules/rails/${name}.conf", "puppet:///modules/rails/empty.conf" ],
    notify   => Exec["reload-nginx"],
  }

  file { [ "/var/www",
  "/var/www/${name}",
  "/var/www/${name}/releases",
  "/var/www/${name}/shared",
  "/var/www/${name}/shared/config",
  "/var/www/${name}/shared/log",
  "/var/www/${name}/shared/system" ]:
    ensure => directory,
    mode   => 775,
    owner  => "www-data",
    group  => "www-data",
  }

}

