class jenkins {

  $home_dir = '/var/lib/jenkins'
  $plugin_dir = "${home_dir}/plugins"
  $plugin_mirror = "http://updates.jenkins-ci.org"

  $user = 'jenkins'
  $group = 'jenkins'

  include jenkins::repo
  include jenkins::package
  include jenkins::service
  include jenkins::firewall

  Class['jenkins::repo'] -> Class['jenkins::package'] ->
    Class['jenkins::service']
}
# vim: ts=2 et sw=2 autoindent
