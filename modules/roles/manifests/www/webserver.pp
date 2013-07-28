class roles::www::webserver (
  $run_as_user,
  $ruby_version = '2.0.0-p247',
  $rails_env,
){

  anchor { "roles::www::webserver::being": } ->

  apt::ppa { ['ppa:chris-lea/node.js', 'ppa:nginx/stable']: } ->

  class { 'roles::www::nodejs': } ->

  class { 'roles::ruby::setup':
    run_as_user => $run_as_user,
  } ->

  roles::ruby::install { "install ${ruby_version}":
    run_as_user => $run_as_user,
    version     => $ruby_version,
    global      => true,
  } ->

  package { 'nginx':
    ensure => present,
  } ->

  service { 'nginx':
    enable => true,
    ensure => running,
  } ->

  class { "puma::init":
    run_as_user => $run_as_user,
    rails_env   => $rails_env,
  } ->

  anchor { "roles::www::webserver::end": }
}

