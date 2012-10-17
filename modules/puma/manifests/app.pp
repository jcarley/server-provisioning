class puma::app($app_path = "", $user = "", $config_file_path = "", $log_file_path = "") {

  if $config_file_path == "" {
    $config_file = "${app_path}/config/puma.rb"
  } else {
    $config_file = $config_file_path
  }

  if $log_file_path == "" {
    $log_file = "${app_path}/config/puma.log"
  } else {
    $log_file = $log_file_path
  }

  file { "${app_path}/tmp/puma":
    ensure => directory,
  }

  exec { add_app:
    command => "/etc/init.d/puma add ${app_path} ${user} ${config_file} ${log_file}",
    require => File["${app_path}/tmp/puma"],
  }

  exec { remove_app:
    command     => "/etc/init.d/puma remove ${app_path}",
    refreshonly => true,
  }
}
