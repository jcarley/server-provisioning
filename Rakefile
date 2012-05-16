PUPPETMASTER = 'linode'
CLIENT = 'linode'
SSH = 'ssh -t -A'

# Checkin code to github, and deploy to puppet master machine (in this case its also the client)
task :deploy do
  sh "git push origin master"
  sh "#{SSH} #{PUPPETMASTER} 'cd ~/puppet && sudo git pull'"
end

# Test changes on client machine
task :apply => [:deploy] do
  sh "#{SSH} #{CLIENT} 'cd ~/puppet && sudo puppet agent --test'" do |ok, status|
    puts case status.exitstatus
      when 0 then "Client is up to date."
      when 1 then "Puppet couldn't compile the manifest."
      when 2 then "Puppet made changes."
      when 4 then "Puppet found errors."
    end
  end
end

# See the changes puppet would make, but don't actually change anything
task :noop => [:deploy] do
  sh "#{SSH} #{CLIENT} 'cd ~/puppet && sudo puppet agent --test --noop'"
end
