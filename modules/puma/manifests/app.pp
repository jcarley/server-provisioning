class puma::app($app_path = "", $user = "", $config_file_path = "", $log_file_path = "") {
  $puma_tmp = "${app_path}/tmp/puma"

  if $config_file_path == "" {
    $config_file = "${app_path}/config/puma.rb"

    file { $config_file:
      content => template('puma/puma_config.erb'),
      ensure  => present,
      owner   => $user,
      group   => $user
    }

  } else {
    $config_file = $config_file_path
  }

  if $log_file_path == "" {
    $log_file = "${app_path}/config/puma.log"
  } else {
    $log_file = $log_file_path
  }

  file { ${puma_tmp}:
    ensure => directory,
  }

  exec { add_app:
    command => "/etc/init.d/puma add ${app_path} ${user} ${config_file} ${log_file}",
    require => [ File["${app_path}/tmp/puma"],
                 File[$config_file] ],
  }

  exec { remove_app:
    command     => "/etc/init.d/puma remove ${app_path}",
    refreshonly => true,
  }
}
