#!/bin/bash

echo
echo "Setup Consul server ..."

touch /etc/consul.d/server.hcl
chown --recursive consul:consul /etc/consul.d
chmod 640 /etc/consul.d/server.hcl

echo "server = true
bootstrap_expect = 1
ui = true
client_addr = \"0.0.0.0\"" > /etc/consul.d/server.hcl