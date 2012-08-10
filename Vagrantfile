# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.customize ["modifyvm", :id, "--name", "app", "--memory", "512"]
  config.vm.box = "precise32_bootstrapped"
  config.vm.host_name = "app"
  config.vm.forward_port 22, 2222, :auto => true
  config.vm.network :hostonly, "33.33.13.37"
  config.vm.share_folder "puppet", "/etc/puppet", "."
  # config.vm.provision :shell, :path => "shell.sh"

  config.vm.provision :puppet do |puppet|
    puppet.pp_path = "/etc/puppet"
    puppet.manifests_path = "manifests"
    puppet.module_path = "modules"
    puppet.manifest_file = "vagrant_site.pp"
    puppet.options = ["--verbose --debug"]
  end

end
