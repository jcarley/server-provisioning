require 'git'
require 'rvm'

namespace :puppet do

  desc 'Verifies the syntax for .pp and .erb files.'
  task :verify do
    g = Git.open('.')
    environment = RVM.current.environment_name
    RVM.with environment do |r|
      g.status.changed.each_key do |file|
        puppet_parse(file, r) if file.end_with?('.pp')
        erb_parse(file, r) if file.end_with?('.erb')
      end
    end
  end

  def puppet_parse(file, r)
    manifest_file = File.expand_path(file)
    msg = r.execute("puppet parser validate #{manifest_file}").join

    puts msg unless msg.empty?
    puts "[#{file}]: Syntax OK" if msg.empty?
  end

  def erb_parse(file, r)
    erb_file = File.expand_path(file)
    msg = r.execute("erb -x -T - #{erb_file} | ruby -c").join

    puts msg unless msg.gsub(/Syntax OK/)
    puts "[#{file}]: Syntax OK" if msg.gsub(/Syntax OK/)
  end

end
