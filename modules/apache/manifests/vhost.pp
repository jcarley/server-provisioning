define apache::vhost( $port, $docroot, $ssl=true, $template='apache/vhost.conf.erb', $priority, $serveraliases = '') {
  include apache

  file {"/etc/apache2/sites-available/${name}":
    content => template($template),
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    require => Class["apache::install"],
  }

  file {"/etc/apache2/sites-enabled/${priority}-${name}":
    ensure => link,
    target => "/etc/apache2/sites-available/${name}",
    require => File["/etc/apache2/sites-available/${name}"],
    notify  => Class["apache::service"],
  }

}
