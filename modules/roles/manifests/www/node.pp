class roles::www::node(
  $version = 'v0.10.5'
) {
  class { "nodejs":
    version => $version,
  }
}

