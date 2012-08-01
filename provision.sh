#!/usr/bin/env bash

get_bundle() {
  (
  if [ -d "$3" ]; then
    echo "Updating $1's $3"
    cd "$3"
    git pull --rebase
  else
    git clone "git://github.com/$1/$2.git" "$3"
  fi
  )
}

cd /etc/puppet/modules
get_bundle puppetlabs puppetlabs-nginx nginx
get_bundle puppetlabs puppetlabs-stdlib stdlib

cd /etc/puppet
puppet apply manifests/site.pp
