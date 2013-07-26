# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.provision :puppet, :module_path => "modules" do |puppet|
    puppet.manifest_file = "site.pp"
    puppet.options << ["--verbose"]
    # puppet.options << ["--graph"]
  end


  config.vm.define :devweb01 do |config|
    hostname = "devweb01"
    # hostname = "ffs-vpc-web01"
    # hostname = "ffs-vpc-jenkins01"

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
    config.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box'

    # config.vm.synced_folder "..", "/home/vagrant/apps", :nfs => true

    config.vm.network :private_network, ip: "33.33.33.27"
    config.vm.network :forwarded_port, guest: 8080, host: 3000, :auto => true

  end

end
