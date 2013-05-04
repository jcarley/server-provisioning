class rails::passenger {

  $as_vagrant = 'sudo -u vagrant -H bash -l -c'
  $home = '/home/vagrant'
  $ruby_home = "${home}/.rbenv/versions/1.9.3-p392"
  $passenger_version = "3.0.19"
  $nginx_version = "1.2.3"

  $passenger_dependencies = [ "build-essential",
                              "libcurl4-openssl-dev",
                              "libssl-dev"]
  package { $passenger_dependencies: ensure => installed }

  exec { "install-bundler":
    command => "${ruby_home}/bin/gem install bundler --no-ri --no-rdoc",
    creates => "${ruby_home}/bin/bundle",
    require => Package[$passenger_dependencies]
  }

  wget::fetch { "download-nginx":
    source      => "http://nginx.org/download/nginx-${nginx_version}.tar.gz",
    destination => "/tmp/nginx-${nginx_version}.tar.gz"
  }

  exec { "untar-nginx":
    command => "tar xzvf /tmp/nginx-${nginx_version}.tar.gz && chown root:root -R /tmp/nginx-${nginx_version}",
    creates => "/tmp/nginx-${nginx_version}",
    cwd     => "/tmp",
    require => Wget::Fetch["download-nginx"]
  }

  exec { "install-passenger":
    command => "${ruby_home}/bin/gem install passenger --version=${passenger_version} --no-ri --no-rdoc",
    unless  => "${ruby_home}/bin/gem list | /bin/grep passenger | /bin/grep ${passenger_version}",
    require => [ Package[$passenger_dependencies], Exec["untar-nginx"] ],
    timeout => "-1",
  }

  exec { "install-passenger-nginx-module":
    command => "${ruby_home}/bin/passenger-install-nginx-module --auto --prefix=/opt/nginx --nginx-source-dir=/tmp/nginx-${nginx_version} --extra-configure-flags=\"--conf-path=/etc/nginx/conf/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --lock-path=/var/lock/nginx.lock --pid-path=/var/run/nginx.pid --sbin-path=/usr/sbin/nginx --with-http_gzip_static_module\"",
    user    => 'root',
    group   => 'root',
    creates => "/usr/sbin/nginx",
    require => Exec["install-passenger"],
    timeout => "-1",
  }

  file { [ "/etc/nginx",
           "/etc/nginx/conf",
           "/etc/nginx/conf/includes",
           "/etc/nginx/conf/sites-enabled",
           "/etc/nginx/conf/sites-available",
           "/var/log/nginx" ]:
    ensure  => directory,
    owner   => "www-data",
    group   => "www-data",
  }

  file { "/etc/nginx/conf/sites-enabled/default":
    ensure  => absent,
    require => Exec["install-passenger-nginx-module"],
  }

  file { "/etc/init.d/nginx":
    ensure  => present,
    source  => "puppet:///modules/rails/nginx.init",
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Exec["install-passenger-nginx-module"],
  }

  exec { 'update-rc.d -f nginx defaults':
    alias   => 'install script',
    creates => '/etc/rc0.d/K20nginx',
    require => File['/etc/init.d/nginx'],
  }

  service { "nginx":
    enable  => true,
    ensure  => running,
    require => [ File["/etc/init.d/nginx"], Exec['update-rc.d -f nginx defaults'] ],
  }

  file { "/etc/nginx/conf/nginx.conf":
    content  => template("rails/nginx.conf.erb"),
    notify   => Exec["reload-nginx"],
    require  => Service["nginx"],
  }

  exec { "reload-nginx":
    command     => "/usr/sbin/service nginx reload",
    refreshonly => true,
    require     => Exec["install-passenger-nginx-module"],
  }

}


