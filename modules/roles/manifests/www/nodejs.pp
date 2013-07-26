class roles::www::nodejs {
  package { 'nodejs':
    ensure => present,
  }
}
