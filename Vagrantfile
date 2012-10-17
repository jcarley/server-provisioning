# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.provision :puppet, :module_path => "modules" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "site.pp"
    puppet.options        = %w[ --libdir=\\$modulepath/rbenv/lib ]
    # puppet.options = ["--verbose --debug"]
  end

  config.vm.define :web01 do |config|
    config.vm.customize ["modifyvm", :id, "--name", "web01", "--memory", "512"]
    config.vm.box = "precise32"
    # config.vm.box = "lucid32"
    # config.vm.box_url = "http://files.vagrantup.com/lucid32.box"
    config.vm.host_name = "web01"
    config.vm.forward_port 22, 2222, :auto => true
    config.vm.forward_port 80, 8080
    config.vm.network :hostonly, "33.33.13.37"
    # config.vm.share_folder "share", "~/share", "."
  end

end
