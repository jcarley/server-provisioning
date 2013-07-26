class puma::service {
  service { 'puma-manager':
    ensure     => running,
    enable     => true,
    provider   => 'upstart',
    hasrestart => true,
  }
}
