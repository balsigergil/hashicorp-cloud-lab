# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  etc_hosts = ""

	NODES = [
  	{ :hostname => "consul-server", :ip => "192.168.33.10", :cpus => 2, :memory => 2048, :type => "consul" },
  	{ :hostname => "nomad-server", :ip => "192.168.33.11", :cpus => 2, :memory => 2048, :type => "nomad" },
  	{ :hostname => "nomad-1", :ip => "192.168.33.12", :cpus => 1, :memory => 1024, :type => "client" },
	]

	# Define /etc/hosts for all servers
  NODES.each do |node|
    etc_hosts += "echo '" + node[:ip] + "   " + node[:hostname] + "' >> /etc/hosts" + "\n"
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

      cfg.vm.provision "shell" do |s|
        s.path = "common_setup.sh"
        s.args = node[:ip]
      end

      if node[:type] === "nomad"
        cfg.vm.provision "shell", path: "nomad_server_setup.sh"
        cfg.vm.provision "shell", path: "nomad_service.sh"
      end

      if node[:type] === "client"
        cfg.vm.provision "shell", path: "nomad_client_setup.sh"
        cfg.vm.provision "shell", path: "nomad_service.sh"
      end

      if node[:type] === "consul"
        cfg.vm.provision "shell", path: "consul_server_setup.sh"
      end

      cfg.vm.provision "shell", path: "consul_service.sh"
  
      cfg.vm.provision :shell, :inline => etc_hosts
    end

  end

end
