class roles::www::puma($run_as_user)
{
  class { "puma::install":
    run_as_user => $run_as_user,
  }
}

