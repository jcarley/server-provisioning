class puma::params {
  case $operatingsystem {
    'CentOS': {
      $startup_script_command = 'chkconfig --add puma'
      $startup_script_resource = 'K50puma'
      $puma_service_file = 'puma-centos'
    }
    /(Ubuntu|Debian)/: {
      $startup_script_command = 'update-rc.d -f puma defaults'
      $startup_script_resource = 'K20puma'
      $puma_service_file = 'puma-ubuntu'
    }
  }
}
