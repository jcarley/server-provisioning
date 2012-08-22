ENV['VAGRANT_LOG'] = "info"

require 'yaml'
require 'fileutils'
require 'highline/import'
require 'rvm/with'
require 'vagrant'

namespace :vm do

  desc 'Start up vm'
  task :start do
    env = Vagrant::Environment.new
    env.cli("up")
  end

  desc 'Shuts down all running vm machines.'
  task :stop do
    env = Vagrant::Environment.new
    env.cli("halt")
  end

  desc 'Starts up a vm, deploys application to it.'
  task :deploy do

  end

  desc 'Removes all VMs'
  task :remove do
    env = Vagrant::Environment.new
    env.cli('destroy', '--force')
  end

  desc 'Prints out vm status'
  task :status do
    env = Vagrant::Environment.new
    env.vms.each do |key, vm|
      puts "[#{key}]: #{vm.state.capitalize.to_s.gsub("_", " ")}"
    end
  end


end
