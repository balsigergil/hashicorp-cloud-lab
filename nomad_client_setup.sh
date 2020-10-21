#!/bin/bash

echo
echo "Setup Nomad client ..."

mkdir --parents /etc/nomad.d
chmod 700 /etc/nomad.d

echo "client {
  enabled = true
}" > /etc/nomad.d/client.hcl