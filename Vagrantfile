# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

HOSTS = 3

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  # Set up Scalaris Peer Nodes
  (0..HOSTS-1).each do |i|
    config.vm.define "host#{i}" do |mon|
      mon.vm.hostname = "scalaris-peer#{i}"
      mon.vm.network :private_network, ip: "192.168.42.10#{i}"
      mon.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "1024"]
      end
      mon.vm.provider :vmware_fusion do |v|
        v.vmx['memsize'] = '1024'
      end
    end
  end

  config.vm.provision "shell", path: "host-setup.sh"
end
