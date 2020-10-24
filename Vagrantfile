# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  etc_hosts = ""

	NODES = [
  	{ :hostname => "consul-server", :ip => "192.168.33.10", :cpus => 2, :memory => 1024 },
  	{ :hostname => "nomad-server", :ip => "192.168.33.11", :cpus => 2, :memory => 1024 },
  	{ :hostname => "node-1", :ip => "192.168.33.12", :cpus => 1, :memory => 512 },
  	{ :hostname => "node-2", :ip => "192.168.33.13", :cpus => 1, :memory => 512 },
	]

	# Define /etc/hosts for all nodes
  NODES.each do |node|
    etc_hosts += node[:ip] + "   " + node[:hostname] + "\n"
  end

  NODES.each do |node|

    config.vm.define node[:hostname] do |cfg|

      cfg.vm.box = "bento/ubuntu-18.04"
  
      cfg.vm.network "private_network", ip: node[:ip]
      cfg.vm.hostname = node[:hostname]
  
    
      cfg.vm.provider "virtualbox" do |vb|
        vb.memory = node[:memory]
        vb.cpus = node[:cpus]
      end
  
    end

  end
  
  config.vm.provision :ansible_local do |ansible|
    ansible.playbook = "provisioning/playbook.yml"
    ansible.groups = {
      "consul" => ["consul-server", "nomad-server", "node-1", "node-2"],
      "nomad" => ["nomad-server", "node-1", "node-2"],
      "nomad_clients" => ["node-1", "node-2"]
    }
    ansible.extra_vars = {
      etc_hosts: etc_hosts
    }
  end

end
