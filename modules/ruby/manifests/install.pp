define ruby::install($ruby_version = '', $ruby_home = "/opt/rubies", $current = true, $home = '/home', $user = 'vagrant') {

  $ruby_current = "${ruby_home}/current"

  if $ruby_version == '' {
    $ruby = $name
  } else {
    $ruby = $ruby_version
  }

  if ! defined(Class['ruby::dependencies']) {
    require ruby::dependencies
  }

  if ! defined(File[$ruby_home]) {
    file { $ruby_home :
      ensure => directory
    }
  }

  exec { "install_ruby_version ${ruby}":
    command => "/usr/local/bin/ruby-build ${ruby} ${ruby_home}/${ruby}",
    cwd     => '/tmp',
    path    => $path,
    creates => "${ruby_home}/${ruby}",
    timeout => 0,
    user    => 'root',
    group   => 'root',
    require => [ Exec['install_ruby_build'], File[$ruby_home] ]
  }

  if $current {
    file { $ruby_current :
      ensure  => link,
      target  => "${ruby_home}/${ruby}",
      require => Exec["install_ruby_version ${ruby}"],
    }
  }

  if ! defined(Exec['set_path']) {
    exec { "set_path":
      cwd      => "${home}/${user}",
      command  => "echo \"export PATH=${ruby_current}/bin:\\\$PATH\" >> .bashrc",
      provider => 'shell',
      user     => $user,
      group    => $user,
      unless   => "grep ${ruby_current} .bashrc",
      require  => File[$ruby_current],
    }
  }

}
