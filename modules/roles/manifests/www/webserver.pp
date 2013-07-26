class roles::www::webserver (
  $run_as_user,
  $rails_env,
){

  anchor { "roles::www::webserver::being": } ->

  class { "nodejs": } ->

  class { "puma::init":
    run_as_user => $run_as_user,
    rails_env   => $rails_env,
  }

  anchor { "roles::www::webserver::end": }
}

