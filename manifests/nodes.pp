node default {
  include stdlib
  include roles::setup
  include java

  $run_as_user = "jenkins"
  $ruby_version = 'jruby-1.7.4'

  package { ['git', 'wget', 'curl', 'vim']:
    ensure => installed,
  } ->

  roles::user { 'install_jenkins_user':
    run_as_user   => $run_as_user,
    password      => 'changeme',
    primary_group => $run_as_user,
    groups        => ['admin', 'sudo', 'adm'],
  } ->

  class { 'roles::www::node': } ->

  class { 'roles::ruby':
    run_as_user => $run_as_user,
    version     => $ruby_version,
  } ->

  class { 'roles::infrastructure': }
}

node dev01 {
  include apt
  include stdlib
  include roles::infrastructure

  $run_as_user = "vagrant"
  $ruby_version = "2.0.0-p247"
  $ruby_home_path = "/home/${run_as_user}/.rbenv/versions/${ruby_version}"
  $base_app_home = "/home/${run_as_user}/apps"

  class { 'roles::setup': }

  package { ['git', 'wget', 'curl', 'vim', 'nfs-common']:
    ensure => installed,
  }

  class { 'java': } ->

  class { 'roles::database': } ->

  class { 'roles::www::webserver':
    run_as_user  => $run_as_user,
    ruby_version => '2.0.0-p247',
    rails_env    => 'development',
  }

}
