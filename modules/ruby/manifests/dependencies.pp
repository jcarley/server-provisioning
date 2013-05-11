class ruby::dependencies {

  if ! defined(Package['git']) { package { 'git': ensure => present } }

  exec { "clone_ruby_build":
    cwd     => '/tmp',
    command => 'git clone git://github.com/sstephenson/ruby-build.git',
    path    => $path,
    unless  => "ls /tmp | grep ruby-build",
    require => Package['git'],
  }

  exec { 'install_ruby_build':
    command => '/tmp/ruby-build/install.sh',
    cwd     => '/tmp/ruby-build',
    path    => $path,
    creates => '/usr/local/bin/ruby-build',
    user    => 'root',
    group   => 'root',
    require => Exec['clone_ruby_build'],
  }
}
