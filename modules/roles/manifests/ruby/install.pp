define roles::ruby::install(
  $run_as_user,
  $version = '2.0.0-p247',
  $global  = true,
) {

  $user_home = "/home/${run_as_user}"

  rbenv::compile { $version:
    user    => $run_as_user,
    home    => $user_home,
    global  => $global,
  }

}
