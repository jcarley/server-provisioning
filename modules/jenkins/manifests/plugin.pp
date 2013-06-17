define jenkins::plugin($version=0) {
  include jenkins

  # $home_dir = '/var/lib/jenkins'
  # $plugin_dir = "${home_dir}/plugins"

  $plugin            = "${name}.hpi"
  # $plugin_dir        = '/var/lib/jenkins/plugins'
  # $plugin_parent_dir = '/var/lib/jenkins'

  if ($version != 0) {
    $base_url = "http://updates.jenkins-ci.org/download/plugins/${name}/${version}/"
  }
  else {
    $base_url   = 'http://updates.jenkins-ci.org/latest/'
  }

  if (!defined(File[$jenkins::plugin_dir])) {
    file {
      [$jenkins::home_dir, $jenkins::plugin_dir]:
        ensure  => directory,
        owner   => $jenkins::user,
        group   => $jenkins::group,
        require => [Group['jenkins'], User['jenkins']];
    }
  }

  if (!defined(Group[$jenkins::group])) {
    group {
      $jenkins::group:
        ensure => present;
    }
  }

  if (!defined(User[$jenkins::user])) {
    user {
      $jenkins::user:
        ensure => present;
    }
  }

  exec {
    "download-${name}" :
      command  => "wget --no-check-certificate ${base_url}${plugin}",
      cwd      => $jenkins::plugin_dir,
      require  => File[$jenkins::plugin_dir],
      path     => ['/usr/bin', '/usr/sbin',],
      user     => $jenkins::user,
      unless   => "test -f ${jenkins::plugin_dir}/${plugin}",
      notify   => Service['jenkins'];
  }
}
