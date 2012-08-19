define nginx::vhost( $sitedomain = "" ) {
  include nginx::install

  if $sitedomain == "" {
    $vhost_domain = $name
  } else {
    $vhost_domain = $sitedomain
  }

  file { "/usr/local/etc/nginx/sites-available/${vhost_domain}.conf":
    content => template("nginx/vhost.erb"),
    require => Exec["nginx install"],
  }

  file { "/usr/local/etc/nginx/sites-enabled/${vhost_domain}.conf":
    ensure => link,
    target => "/usr/local/etc/nginx/sites-available/${vhost_domain}.conf",
    require => File["/usr/local/etc/nginx/sites-available/${vhost_domain}.conf"],
    notify => Exec["reload nginx"],
  }
}
