class roles::user($run_as_user, $ssh_pub_key) {

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
