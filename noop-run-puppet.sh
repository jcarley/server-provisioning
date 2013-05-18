rsync -nrt --verbose --progress --stats --compress --links --delete --exclude-from=exclude.txt ./ root@$1:/etc/puppet
