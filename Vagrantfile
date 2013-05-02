# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.provision :puppet, :module_path => "modules" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "site.pp"
    # puppet.options = ["--verbose --debug"]
  end

  config.vm.define :moshpitvm do |config|

    config.vm.customize ["modifyvm", :id,
                         "--name", "moshpitvm",
                         "--memory", "1024",
                         "--cpus", "2",
                         "--nictype1", "Am79C973",
                         "--nictype2", "Am79C973"]

    config.vm.box = "precise64"
    config.vm.host_name = "moshpitvm"

    config.vm.forward_port 22, 2222, :auto => true
    config.vm.forward_port 80, 8080

    config.vm.network :hostonly, "33.33.13.37"
    config.vm.share_folder "v-root", "/vagrant", ".", :nfs => true
  end

end
