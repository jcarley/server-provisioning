class nginx {
  package { "nginx": ensure => installed }

  service { "nginx":
    enable => true,
    ensure => running,
  }

  exec { "reload nginx":
    command => "/usr/sbin/service nginx reload",
    require => Package["nginx"],
    refreshonly => true,
  }

  file { "/etc/nginx/nginx.conf":
    source => "puppet:///modules/nginx/nginx.conf",
    notify => Exec["reload nginx"],
    require => Package["nginx"],
  }
}

define nginx::site( $sitedomain = "" ) {
  include nginx

  if $sitedomain == "" {
    $vhost_domain = $name
  } else {
    $vhost_domain = $sitedomain
  }

  file { "/etc/nginx/sites-available/${vhost_domain}.conf":
    content => template("nginx/vhost.erb"),
    require => Package["nginx"],
  }

  file { "/etc/nginx/sites-enabled/${vhost_domain}.conf":
    ensure => link,
    target => "/etc/nginx/sites-available/${vhost_domain}.conf",
    require => File["/etc/nginx/sites-available/${vhost_domain}.conf"],
    notify => Exec["reload nginx"],
  }
}
