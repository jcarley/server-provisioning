
class server::base {
  include ssh

  exec { "apt-update":
    command => "/usr/bin/apt-get update",
  }
  Exec["apt-update"] -> Package <| |>

  group { "puppet":
    ensure  => "present",
  }

}
