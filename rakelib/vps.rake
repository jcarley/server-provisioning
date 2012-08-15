
namespace :vps do

  TARGET = 'linode'
  SSH = 'ssh -t -A'

  desc "Pushes changes to Github master branch"
  task :checkin do
    sh "git push origin master"
  end

  desc 'Bootstraps a vps server with build essentials.'
  task :bootstrap => [:checkin] do
    sh "#{SSH} #{TARGET} 'curl -L https://raw.github.com/jcarley/server-provisioning/master/bootstrap/server-bootstrap.sh | bash'"
  end

  # Checkin code to github, and deploy to puppet master machine (in this case its also the client)
  desc 'Deploys puppet script changes to vps.  Does not run puppet.'
  task :deploy => [:checkin] do
    sh "#{SSH} #{TARGET} 'cd /etc/puppet && git pull origin master'"
  end

  # Test changes on client machine
  desc 'Applies puppet script changes to vps.'
  task :apply => [:deploy] do
    sh "#{SSH} #{TARGET} 'cd /etc/puppet && ./provision.sh'" do |ok, status|
      puts case status.exitstatus
        when 0 then "Client is up to date."
        when 1 then "Puppet couldn't compile the manifest."
        when 2 then "Puppet made changes."
        when 4 then "Puppet found errors."
      end
    end
  end

  # See the changes puppet would make, but don't actually change anything
  desc 'Tests the puppet script changes without making any changes.'
  task :noop => [:deploy] do
    sh "#{SSH} #{TARGET} 'cd /etc/puppet && puppet apply --test --noop'"
  end

end
