TARGET = 'linode'
SSH = 'ssh -t -A'

task :checkin do
  sh "git push origin master"
end

task :bootstrap => [:checkin] do
  sh "#{SSH} #{TARGET} 'curl -L https://raw.github.com/jcarley/server-provisioning/master/bootstrap/server-bootstrap.sh | bash'"
end

# Checkin code to github, and deploy to puppet master machine (in this case its also the client)
task :deploy => [:checkin] do
  sh "#{SSH} #{TARGET} 'cd /etc/puppet && git pull origin master'"
end

#task :provision => [:deploy] do
  #sh "#{SSH} #{TARGET} 'cd /etc/puppet && chef-solo -c solo.rb'"
#end

# Test changes on client machine
task :apply => [:deploy] do
  sh "#{SSH} #{TARGET} 'cd /etc/puppet && sudo ./provision.sh'" do |ok, status|
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
  sh "#{SSH} #{TARGET} 'cd /etc/puppet && puppet agent --test --noop'"
end
