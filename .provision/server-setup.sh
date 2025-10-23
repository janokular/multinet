#!/bin/bash

# Check if script was run with sudo privileges
if [[ $(id -u) -ne 0 ]]; then
  echo 'Please run with sudo or as a root.' >&2
  exit 1
fi

# Set the password for the vagrant user 
echo 'vagrant:vagrant' | chpasswd

# Copy ssh server configuration file 
cp /vagrant/.provision/config/sshd_config /etc/ssh/

# Restart the ssh server
service ssh restart
