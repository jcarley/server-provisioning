define nginx::vhost( $port = 80, $sitedomain = "", $template='nginx/vhost.erb' ) {
  include nginx::install

  if $sitedomain == "" {
    $vhost_domain = $name
  } else {
    $vhost_domain = $sitedomain
  }

  file { "/usr/local/etc/nginx/sites-available/${vhost_domain}.conf":
    content => template($template),
    owner   => 'www-data',
    group   => 'www-data',
    mode    => 0644,
    require => Class['nginx::install'],
  }

  file { "/usr/local/etc/nginx/sites-enabled/${vhost_domain}.conf":
    ensure => link,
    target => "/usr/local/etc/nginx/sites-available/${vhost_domain}.conf",
    require => File["/usr/local/etc/nginx/sites-available/${vhost_domain}.conf"],
    notify => Exec['reload nginx'],
  }
}
