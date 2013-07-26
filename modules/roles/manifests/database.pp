class roles::database {

  package { ['mysql-server', 'libmysqlclient-dev']:
    ensure => present,
  } ->

  service { 'mysql':
    enable => true,
    ensure => running,
  }
}
