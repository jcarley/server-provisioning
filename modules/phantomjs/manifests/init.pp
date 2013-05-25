class phantomjs {
  exec { 'install-phantomjs':
    command => 'curl http://phantomjs.googlecode.com/files/phantomjs-1.8.1-linux-x86_64.tar.bz2 | sudo tar xjfv - &&
    sudo ln -s /usr/local/share/phantomjs-1.8.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs',
    cwd     => '/usr/local/share',
    creates => '/usr/local/bin/phantomjs'
  }
}
