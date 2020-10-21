#!/bin/bash

echo
echo "Updating system ..."
apt-get update &>/dev/null
apt-get upgrade -yqq &>/dev/null
apt-get install -yqq curl unzip openjdk-11-jdk &>/dev/null

# Docker installation
echo
echo "Docker installation ..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh &>/dev/null
usermod -aG docker vagrant

# Nomad installation

export NOMAD_VERSION="0.12.6"
echo
echo "Installing Nomad ${NOMAD_VERSION} ..."
curl --silent --remote-name \
    https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip
unzip nomad_${NOMAD_VERSION}_linux_amd64.zip
rm nomad_${NOMAD_VERSION}_linux_amd64.zip
chown root:root nomad
mv nomad /usr/local/bin/

runuser -l vagrant -c "nomad -autocomplete-install" &>/dev/null
runuser -l vagrant -c "complete -C /usr/local/bin/nomad nomad" &>/dev/null

mkdir --parents /opt/nomad
mkdir --parents /etc/nomad.d
chmod 700 /etc/nomad.d

echo "datacenter = \"dc1\"
data_dir = \"/opt/nomad\"
bind_addr = \"$1\"" > /etc/nomad.d/nomad.hcl

echo "export NOMAD_ADDR=http://${1}:4646" >> /home/vagrant/.bashrc

# Consul installation
export CONSUL_VERSION="1.8.4"
export CONSUL_URL="https://releases.hashicorp.com/consul"
export CONSUL_KEY="VRXNV3bMNRJBAEq20xBe+FOBcUO68ztFgHuXkzovO5U="

echo
echo "Installing Consul ${CONSUL_VERSION} ..."

curl --silent --remote-name \
    ${CONSUL_URL}/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
unzip consul_${CONSUL_VERSION}_linux_amd64.zip
chown root:root consul
mv consul /usr/local/bin/

runuser -l vagrant -c "consul -autocomplete-install"
runuser -l vagrant -c "complete -C /usr/local/bin/consul consul"

useradd --system --home /etc/consul.d --shell /bin/false consul
mkdir --parents /opt/consul
chown --recursive consul:consul /opt/consul

mkdir --parents /etc/consul.d
touch /etc/consul.d/consul.hcl
chown --recursive consul:consul /etc/consul.d
chmod 640 /etc/consul.d/consul.hcl

echo "datacenter = \"dc1\"
data_dir = \"/opt/consul\"
encrypt = \"${CONSUL_KEY}\"
advertise_addr = \"$1\"
bind_addr = \"$1\"
enable_script_checks = true
retry_join = [\"192.168.33.10\"]" > /etc/consul.d/consul.hcl