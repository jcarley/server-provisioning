import 'base_node'
import 'web_servers'

node 'web01' {
  include 'production_web01'
}

node 'web02' {
  include base
  include apache

  user { "deployer":
    ensure     => 'present',
    shell      => '/bin/zsh',
    groups     => ['adm', 'admin'],
    home       => '/home/deployer',
    managehome => true,
  }

  file { "/home/deployer/apps":
    ensure  => directory,
    owner   => 'deployer',
    group   => 'deployer',
    require => User["deployer"],
  }

  apache::vhost { 'www.finishfirstsoftware.com':
    port          => 80,
    docroot       => '/home/deployer/apps/www.finishfirstsoftware.com',
    ssl           => false,
    priority      => 10,
    serveraliases => 'home.finishfirstsoftware.com',
    require       => File ["/home/deployer/apps"],
  }

}

