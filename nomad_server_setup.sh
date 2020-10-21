#!/bin/bash

echo
echo "Setup Nomad server ..."

mkdir --parents /etc/nomad.d
chmod 700 /etc/nomad.d

echo "server {
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled = true
}" > /etc/nomad.d/server.hcl