define puma::app($app_path = "", $user = "", $config_file_path = "", $log_file_path = "") {

  $puma_tmp = "${app_path}/tmp/puma"
  $uid = $user

  if $config_file_path == "" {
    $config_file = "${app_path}/config/puma.rb"

    file {
      "${app_path}/config":
        ensure => directory;
      $config_file:
        content => template('puma/puma_config.erb'),
        ensure  => present,
    }

  } else {
    $config_file = $config_file_path
  }

  if $log_file_path == "" {
    $log_file = "${app_path}/config/puma.log"
  } else {
    $log_file = $log_file_path
  }

  file { [ "${app_path}/tmp",
           "${app_path}/tmp/puma"]:
    ensure  => directory,
  }

  exec { add_app:
    command => "/etc/init.d/puma add ${app_path} ${uid} ${config_file} ${log_file}",
    unless  => "grep ${app_path} /etc/puma.conf",
    path    => $path,
    require => [ File["${app_path}/tmp/puma"],
                 File[$config_file] ],
  }

  # This is here for future use
  # exec { remove_app:
    # command     => "/etc/init.d/puma remove ${app_path}",
    # refreshonly => true,
  # }
}
