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

  file {
    "/home/${run_as_user}/.gemrc":
      content => "
      :verbose: true
      :update_sources: true
      :backtrace: false
      :bulk_threshold: 1000
      :benchmark: false
      gem: --no-ri --no-rdoc
      "
  }

  Rbenv::Install["${run_as_user}"] -> Rbenv::Compile["${version}"]
}
