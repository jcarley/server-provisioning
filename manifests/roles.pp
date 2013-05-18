class roles::setup {
  exec { "apt-update":
    command => "/usr/bin/apt-get update",
  }
}

class roles::ruby($run_as_user, $version = '2.0.0-p0') {

  rbenv::install { "${run_as_user}":
    group   => "${run_as_user}",
    home    => "/home/${run_as_user}",
    rc      => ".bashrc",
  }

  rbenv::compile { "${version}":
    user    => "${run_as_user}",
    home    => "/home/${run_as_user}",
    global  => true,
  }

  Rbenv::Install["${run_as_user}"] -> Rbenv::Compile["${version}"]
}

class roles::app::user($run_as_user, $ssh_pub_key) {
  group { "admin":
    ensure => "present",
  }

  user { $run_as_user:
    ensure     => 'present',
    shell      => '/bin/bash',
    groups     => ['admin'],
    home       => "/home/${run_as_user}",
    managehome => true,
  }

  file { "/home/${run_as_user}":
    ensure  => directory,
    owner   => $run_as_user,
    group   => $run_as_user,
  }

  ssh::user { $run_as_user:
    key => $ssh_pub_key,
  }

  Group['admin'] -> User["${run_as_user}"] -> File["/home/${run_as_user}"] ->
  Ssh::User["${run_as_user}"]
}

class roles::infrastructure {
  include ufw

  ufw::allow { "allow-ssh-from-all":
    port    => 22,
  }

  ufw::allow { "allow-http-from-all":
    port => 80,
  }
}

class roles::www::puma($ruby_home)
{
  class { "puma::install":
    ruby_home => $ruby_home,
  }
}

class roles::www::passenger(
  $passenger_version = '4.0.2',
  $ruby_home,
  $gem_path,
  $application_name,
  $sitedomain
) {
  rails::app { $application_name:
    passenger_version => $passenger_version,
    ruby_home         => $ruby_home,
    gem_path          => $gem_path,
    sitedomain        => $sitedomain,
    runstage          => $stage,
  }
}

class roles::www::node(
  $version = 'v0.10.5'
) {
  class { "nodejs":
    version => $version,
    stage   => $stage,
  }
}
