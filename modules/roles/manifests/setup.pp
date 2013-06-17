class roles::setup {
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/'] }

  exec { "apt-update":
    command => "/usr/bin/apt-get update",
  }

  Exec['apt-update'] -> Package <| |>
}
