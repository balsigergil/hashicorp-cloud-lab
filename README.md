# HashiCorp Vagrant Lab

The goal of this [Vagrantfile](https://github.com/balsigergil/hashicorp-vagrant-lab/blob/master/Vagrantfile) is to play with [HashiCorp](https://www.hashicorp.com/)'s products and simulate a small cloud infrastructure in a virtualized environment.

## Getting started

**Prerequisite**: [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) must be installed.

```shell
git clone https://github.com/balsigergil/hashicorp-vagrant-lab.git
cd hashicorp-vagrant-lab
vagrant up
```

## What's in the box

This Vagrantfile deploys the following services on 3 virtual machines :

- 1 Consul server (VM 1) : [http://192.168.33.10:8500/ui](http://192.168.33.10:8500/ui)
- 1 Nomad server (VM 2) : [http://192.168.33.11:4646/ui](http://192.168.33.11:4646/ui)
- 2 Nomad clients (VM 2 and 3) : 192.168.33.11, 192.168.33.12

## TODO
- Integrate [Vault](https://www.vaultproject.io/)
- Integrate [Terraform](https://www.terraform.io/)
- Setup a load balancer (Fabio, Traefik or HAProxy)
- Setup [ELK Stack](https://www.elastic.co/what-is/elk-stack)
- Integrate [Waypoint](https://www.waypointproject.io/)
- Integrate [Boundary](https://www.boundaryproject.io/)
