class jruby {
  $jruby_home = "/opt/jruby"

  package { "openjdk-7-jdk":
    ensure => present,
  }

  exec { "download_jruby":
    command => "wget -O /tmp/jruby.tar.gz http://jruby.org.s3.amazonaws.com/downloads/1.7.0.RC2/jruby-bin-1.7.0.RC2.tar.gz",
    path => $path,
    unless => "ls /opt | grep jruby-1.7.0.RC2",
    require => Package["openjdk-7-jdk"]
  }

  exec { "unpack_jruby" :
    command => "tar -zxf /tmp/jruby.tar.gz -C /opt",
    path => $path,
    creates => "${jruby_home}-1.7.0.RC2",
    require => Exec["download_jruby"]
  }

  file { $jruby_home :
    ensure => link,
    target => "${jruby_home}-1.7.0.RC2",
    require => Exec["unpack_jruby"]
  }

  file { "${jruby_home}-1.7.0.RC2/bin/ruby":
    ensure  => link,
    target  => "${jruby_home}-1.7.0.RC2/bin/jruby",
    require => File[$jruby_home],
  }

}
