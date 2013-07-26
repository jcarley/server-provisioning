define puma::app(
  $app_path         = "",
  $run_as_user      = "",
  $config_file_path = "",
  $ensure           = "present",
  $port             = "",
  $ruby_home_path   = "/home/${run_as_user}/.rbenv/shims",
  $rails_env        = "development",
) {

  $app_path1 = regsubst($app_path, '/', '')
  $puma_tmp_file = regsubst($app_path1, '/', '_', 'G')
  $puma_tmp_root = '/tmp/puma/'
  $puma_tmp = "${puma_tmp_root}${puma_tmp_file}"

  $uid = $run_as_user

  if $rails_env == 'production' {
    $bundle_opts = "--without development test"
  } else {
    $bundle_opts = ""
  }

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

  if ! defined(File[$puma_tmp_root]) {
    file { $puma_tmp_root:
      ensure => directory,
      owner  => $run_as_user,
      group  => $run_as_user,
    }
  }

  if $ensure == "present" {
    line { "add-app ${app_path}":
      file => "/etc/puma.conf",
      line => $app_path,
      require => File[$config_file],
    }

    exec {"run bundle ${app_path}":
      command => "${ruby_home_path}/bin/bundle install ${bundle_opts}",
      cwd     => $app_path,
      path    => [$path, "${path}:/bin:/usr/bin", "${ruby_home_path}/bin"],
      user    => 'root',
      group   => 'root',
      timeout => 0,
      notify  => Exec["run puma ${app_path}"],
    }

    exec { "run puma ${app_path}":
      command     => "sudo restart puma-manager",
      path        => "${ruby_home_path}/bin:${path}",
      user        => $run_as_user,
      group       => $run_as_user,
      refreshonly => true,
    }

  } else {
    line { "remove-app ${app_path}":
      file    => "/etc/puma.conf",
      line => $app_path,
      require => File[$config_file],
    }
  }

}
