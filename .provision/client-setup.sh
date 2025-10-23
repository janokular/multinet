#!/bin/bash

# Check if script was run with sudo privileges
if [[ $(id -u) -ne 0 ]]; then
  echo 'Please run with sudo or as a root.' >&2
  exit 1
fi

# Append servers to /etc/hosts
echo '10.9.8.11 server01' | tee -a /etc/hosts
echo '10.9.8.12 server02' | tee -a /etc/hosts

# Generate SSH keys for vagrant user
ssh-keygen -t rsa -f /home/vagrant/.ssh/id_rsa -N '' &> /dev/null

# Change SSH keys ownership for vagrant user
chown vagrant /home/vagrant/.ssh/id_*

# Install sshpass
apt-get update &> /dev/null
apt-get install -y sshpass &> /dev/null

# Put the public key on the remote systems
sudo -H -u vagrant bash -c "sshpass -p 'vagrant' ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub server01" &> /dev/null
sudo -H -u vagrant bash -c "sshpass -p 'vagrant' ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub server02" &> /dev/null

# Uninstall sshpass
apt-get purge -y sshpass &> /dev/null
apt-get autoremove &> /dev/null