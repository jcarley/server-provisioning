PUPPETMASTER = 'cookbook'
SSH = 'ssh -t -A'

task :deploy do
  sh "git push"
  sh "#{SSH} #{PUPPETMASTER} 'cd /etc/puppet && sudo git pull'"
end
