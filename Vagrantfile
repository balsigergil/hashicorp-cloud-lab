# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  etc_hosts = ""

  NODES = [
    { :hostname => "server", :ip => "192.168.56.10", :cpus => 4, :memory => 8192 },
    { :hostname => "node-1", :ip => "192.168.56.11", :cpus => 4, :memory => 4096 },
    { :hostname => "node-2", :ip => "192.168.56.12", :cpus => 4, :memory => 4096 },
  ]

  # Define /etc/hosts for all nodes
  NODES.each do |node|
    etc_hosts += node[:ip] + "   " + node[:hostname] + "\n"
  end

  NODES.each do |node|

    config.vm.define node[:hostname] do |cfg|
      cfg.vm.box = "bento/ubuntu-20.04"
  
      cfg.vm.network "private_network", ip: node[:ip]
      cfg.vm.hostname = node[:hostname]
  
    
      cfg.vm.provider "virtualbox" do |vb|
        vb.memory = node[:memory]
        vb.cpus = node[:cpus]
      end
  
    end # End config.vm.define

  end # End NODES.each
  
  config.vm.provision :ansible_local do |ansible|
    ansible.playbook = "provisioning/playbook.yml"
    ansible.extra_vars = {
      etc_hosts: etc_hosts
    }
  end

end # End Vagrant.configure
