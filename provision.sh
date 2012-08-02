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
# get_bundle uggedal puppet-module-nginx nginx
get_bundle uggedal puppet-module-ufw ufw
get_bundle akumria puppet-postgresql postgresql
get_bundle uggedal puppet-module-monit monit
get_bundle alup puppet-rbenv rbenv

cd /etc/puppet
puppet apply manifests/site.pp
