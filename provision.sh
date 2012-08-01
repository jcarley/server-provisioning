#!/usr/bin/env bash

get_bundle() {
  (
  if [ -d "$2" ]; then
    echo "Updating $1's $2"
    cd "$2"
    git pull --rebase
  else
    git clone "git://github.com/$1/$2.git"
  fi
  )
}

cd /etc/puppet/modules
get_bundle puppetlabs puppetlabs-nginx

cd /etc/puppet
puppet apply manifests/site.pp
