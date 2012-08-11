# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.provision :puppet, :module_path => "modules" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "vagrant_site.pp"
    # puppet.options = ["--verbose --debug"]
  end

  config.vm.define :web01 do |config|
    config.vm.customize ["modifyvm", :id, "--name", "app", "--memory", "512"]
    config.vm.box = "precise32_bootstrapped"
    config.vm.host_name = "app"
    config.vm.forward_port 22, 2222, :auto => true
    config.vm.forward_port 80, 8000
    config.vm.network :hostonly, "33.33.13.37"
  end

end
