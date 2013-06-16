define roles::user(
  $run_as_user,
  $ssh_pub_key   = undef,
  $password      = undef,
  $primary_group = undef,
  $groups        = [],
) {

  group { $groups:
    ensure => present,
  } ->

  group { $primary_group:
    ensure => present,
  } ->

  user { $run_as_user:
    comment    => $run_as_user,
    password   => sha1($password),
    ensure     => 'present',
    shell      => '/bin/bash',
    gid        => $primary_group,
    groups     => $groups,
    home       => "/home/${run_as_user}",
    membership => minimum,
    managehome => true,
  } ->

  exec { "$run_as_user homedir":
    command => "/bin/cp -R /etc/skel /home/$run_as_user; /bin/chown -R $run_as_user:$primary_group /home/$run_as_user",
    creates => "/home/$run_as_user",
    require => User[$run_as_user],
  }

  if $ssh_pub_key {
    ssh::user { $run_as_user:
      key     => $ssh_pub_key,
      require => User[$run_as_user],
    }
  }

}
