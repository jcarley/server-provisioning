class jenkins::repo::debian {

  $install_source = 'http://pkg.jenkins-ci.org/debian/binary/jenkins_1.517_all.deb'

  $install_command = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => "wget \'${install_source}\' -O /tmp/jenkins.deb ; dpkg -i /tmp/jenkins.deb",
  }

  package {
    'daemon':
      ensure => installed;
  }

  exec { "install_jenkins_package":
    command     => $install_command,
  }

  Package['daemon'] -> Exec['install_jenkins_package']
}
