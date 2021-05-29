# HashiCorp Vagrant Lab

The goal of this [Vagrantfile](https://github.com/balsigergil/hashicorp-vagrant-lab/blob/master/Vagrantfile) is to try some of [HashiCorp](https://www.hashicorp.com/)'s products and simulate a small cloud infrastructure in a virtualized environment with Vagrant.

## Getting started

**Prerequisite**: [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) must be installed on your machine.

Feel free to change the VM's specs in the `Vagrantfile` on lines 9 to 11 before launching them. You can also add or remove nodes by adding or removing lines in the `NODES` array.

```shell
git clone https://github.com/balsigergil/hashicorp-vagrant-lab.git
cd hashicorp-vagrant-lab
vagrant up
```

## What's in the box

This Vagrantfile deploys the following services on 3 virtual machines :

- 1 Consul server (VM 1) : [http://192.168.33.10:8500/ui](http://192.168.33.10:8500/ui)
- 1 Nomad server (VM 1) : [http://192.168.33.10:4646/ui](http://192.168.33.10:4646/ui)
- 1 Vault server (VM 1) : [http://192.168.33.10:8200/ui](http://192.168.33.10:8200/ui)
- 3 Nomad clients (VM 1, 2 and 3) : 192.168.33.10, 192.168.33.11, 192.168.33.12

**Note**: The Nomad server is a Nomad client too.

It uses [Ansible](https://docs.ansible.com/ansible/latest/index.html) to provision all machines.

## Known issues

- When using Consul Service mesh Envoy crashed :
    ```
    envoy_bootstrap: error creating bootstrap configuration for Connect proxy sidecar: exit status 1
    ```
