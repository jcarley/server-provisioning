node ffs-vpc-jenkins01 {
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

  class { 'jenkins':
    require => Class['java'],
  } ->

  file { ["/home/${run_as_user}/jobs",
          "/home/${run_as_user}/jobs/workspace",
          "/home/${run_as_user}/jobs/builds" ]:
    ensure => directory,
    owner  => "${run_as_user}",
    group  => "${run_as_user}",
  } ->

  # class { 'roles::www::node': } ->

  class { 'roles::ruby':
    run_as_user => $run_as_user,
    version     => $ruby_version,
  } ->

  class { 'roles::infrastructure': } ->

  jenkins::plugin {
        ["git",
        "git-client",
        "ec2",
        "s3",
        "ruby",
        "thinBackup",
        "chucknorris",
        "ansicolor",
        "copy-to-slave",
        "nodelabelparameter",
        "copyartifact",
        "jquery",
        "parameterized-trigger",
        "token-macro",
        "join",
        "slave-setup"]:
      require => Class['jenkins'],
  }
}


node ffs-vpc-web01 {
  include stdlib

  $run_as_user = "deployer"
  $ruby_version = 'jruby-1.7.4'
  # $ruby_version = '2.0.0-p0'
  # $ruby_version = '1.9.3-p392'
  # $passenger_version = "4.0.2"
  $ruby_home = "/home/${run_as_user}/.rbenv/versions/${ruby_version}"

  class { 'roles::setup': }

  # =========== Standard Packages
  package { ['vim', 'openjdk-7-jdk']:
    ensure => present,
  }

  class { "mongodb":
    init         => 'upstart',
    enable_10gen => true,
  }

  # =========== User
  class { 'roles::app::user':
    run_as_user => $run_as_user,
    ssh_pub_key => "AAAAB3NzaC1yc2EAAAABIwAAAQEAx/t0A139x5hD/k/mrAvcsEstchQ6NiEce4Jt5ZvyUBXEjgMUB2A9BJxwlbORLbRp+PBk37n0lEIt3hYIDbrMRQzB6mFYtlEFptmGBxlCyfgzNawwG9TotJKYro8t7w9C1nH7l2ZVDS7NwfJly+gwDoUg/6A/yE38mOhQkDY8RweFeaVE8UaOe0VP3ilyCcdMdcBW//j+6juuRhbZXkD1sDUN866I9q5ovJBDf9sBTvmWD35irb4svW9kYmVdcXj3a8XHOGN8L+bWgzkyxG3x3kqonq6sBF8q0/awVVE2c8Or9oBmeBzcw3pwwSk3ZX/ms3zlGpnBMWplFOnBrz8bdw==",
  }

  # =========== Ruby runtime
  class { 'roles::ruby':
    run_as_user => $run_as_user,
    version     => $ruby_version,
  }

  # =========== Infrastructure
  class { 'roles::infrastructure': }

  # =========== Application
  class { 'roles::www::puma':
    ruby_home => $ruby_home,
  }

  class { 'roles::www::node': }

  file {[ "/home/${run_as_user}/apps/",
          "/home/${run_as_user}/apps/jeffersoncarley" ]:
    ensure => directory,
    before => Puma::App['jeffersoncarley.com'],
  }

  puma::app { "jeffersoncarley.com":
    app_path => "/home/${run_as_user}/apps/jeffersoncarley",
    user     => $run_as_user,
    ensure   => absent,
  }

  # class { 'roles::www::passenger':
    # passenger_version => $passenger_version,
    # ruby_home         => $ruby_home,
    # gem_path          => "${ruby_home}/lib/ruby/gems/shared/gems",
    # application_name  => 'jeffersoncarley',
    # sitedomain        => 'jeffersoncarley.com',
    # stage             => 'setup_app',
  # }

  Class['roles::setup'] -> Package['openjdk-7-jdk'] -> Class['mongodb'] -> Class['roles::app::user'] ->
    Class['roles::ruby'] -> Class['roles::infrastructure'] -> Class['roles::www::puma'] -> Class['roles::www::node'] ->
    Puma::App['jeffersoncarley.com']
}
