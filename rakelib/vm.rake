# ENV['VAGRANT_LOG'] = "info"


namespace :vm do

  desc 'Start up vm'
  task :start do
    # env = Vagrant::Environment.new
    # env.vms.each do |key, vm|
      # puts "[#{key}]: Starting up "
      # vm.up
    # end
  end

  desc 'Shuts down all running vm machines.'
  task :stop do
    # env = Vagrant::Environment.new
    # env.vms.each do |key, vm|
      # puts "[#{key}]: Shutting down"
      # vm.halt
    # end
  end

  desc 'Starts up a vm, deploys application to it.'
  task :deploy do

  end

  desc 'Removes all VMs'
  task :remove do
    # env = Vagrant::Environment.new
    # env.vms.each do |key, vm|
      # puts "[#{key}]: Removing"
      # vm.halt if vm.state == :running
      # vm.destroy
    # end
  end

  desc 'Prints out vm status'
  task :status do
    # env = Vagrant::Environment.new
    # env.vms.each do |key, vm|
      # puts "[#{key}]: #{vm.state.capitalize.to_s.gsub("_", " ")}"
    # end
  end


end
