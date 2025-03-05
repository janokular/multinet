#!/bin/bash

# Check if script was run with sudo privileges
if [[ $(id -u) -ne 0 ]]
then
  echo 'Please run with sudo or as a root.' >&2
  exit 1
fi

# Append servers to /etc/hosts
echo '10.9.8.11 server01' | tee -a /etc/hosts
echo '10.9.8.12 server02' | tee -a /etc/hosts

# Create SSH rsa key pair
# ssh-keygen -t rsa -f ~/.ssh/id_rsa.pub -N ""

# Put the public key on the remote systems
# ssh-copy-id -i ~/.ssh/id_rsa.pub server01
# ssh-copy-id -i ~/.ssh/id_rsa.pub server02