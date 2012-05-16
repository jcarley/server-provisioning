class jruby {
  $jruby_home = "/opt/jruby"

  exec { "download_jruby" :
    command => "wget -O /tmp/jruby.tar.gz http://bit.ly/jruby-167",
    path => $path,
    unless => "ls /opt | grep jruby-1.6.7",
    require => Package["openjdk-6-jdk"]
  }

  exec { "unpack_jruby" :
    command => "tar -zxf /tmp/jruby.tar.gz -C /opt",
    path => $path,
    creates => "${jruby_home}-1.6.7",
    require => Exec["download_jruby"]
  }

  file { $jruby_home :
    ensure => link,
    target => "${jruby_home}-1.6.7",
    require => Exec["unpack_jruby"]
  }
}
