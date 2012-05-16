PUPPETMASTER = 'root'
SSH = 'ssh -t -A'

task :deploy do
  sh "git push origin master"
  sh "#{SSH} #{PUPPETMASTER} 'cd ~/puppet && sudo git pull'"
end
