define puma::app(
  $app_path         = "",
  $user             = "",
  $puma_tmp         = "/tmp/puma",
  $config_file_path = "",
  $ensure           = "present",
) {

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

  if $ensure == "present" {
    line { "add-app ${app_path}":
      file => "/etc/puma.conf",
      line => $app_path,
      require => File[$config_file],
    }
  } else {
    line { "remove-app ${app_path}":
      file    => "/etc/puma.conf",
      line => $app_path,
      require => File[$config_file],
    }
  }

}
