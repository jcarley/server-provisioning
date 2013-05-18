define puma::app(
  $app_path         = "",
  $user             = "",
  $config_file_path = "",
  $ensure           = "present",
) {

  $puma_tmp = "/tmp/puma"
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

  file { "${puma_tmp}",
    ensure  => directory,
  }

  if $ensure == "present" {
    exec { add_app:
      command => "echo ${app_path} >> /etc/puma.conf",
      user    => 'root',
      group   => 'root',
      unless  => "grep -q ${app_path} /etc/puma.conf",
      path    => [$path, '/bin', '/usr/bin', '/usr/sbin'],
      require => File[$config_file],
    }
  } else {
    # exec { remove_app:
      # command => "/etc/init.d/puma add ${app_path} ${uid} ${config_file}",
      # unless  => "grep ${app_path} /etc/puma.conf",
      # path    => $path,
      # require => [ File["${app_path}/tmp/puma"],
                   # File[$config_file] ],
    # }
  }

}
