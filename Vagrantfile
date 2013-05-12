# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.provision :puppet, :module_path => "modules" do |puppet|
    puppet.manifest_file = "site.pp"
    puppet.options = ["--verbose --debug"]
    # puppet.options = ["--graph"]
  end

  config.vm.define :ffs_vpc_web01 do |config|

    hostname = "ffs-vpc-web01"

    config.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id,
                   "--name", "#{hostname}",
                   "--memory", "1024",
                   "--cpus", "2",
                   "--nictype1", "Am79C973",
                   "--nictype2", "Am79C973",
                   "--natdnshostresolver1", "on"]
    end

    config.vm.hostname = hostname
    config.vm.box = "precise64"
    config.vm.box_url = 'http://files.vagrantup.com/precise64.box'

    config.vm.network :private_network, ip: "33.33.33.27"
    config.vm.network :forwarded_port, guest: 80, host: 2727, :auto => true

  end

end
