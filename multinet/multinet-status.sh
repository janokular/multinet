#!/bin/bash

# This script pings a list of servers and reports their status

server_file='/vagrant/multinet/servers'

# Check if server_file exists
if [[ ! -e "${server_file}" ]]; then
  echo "Cannot open ${server_file}" >&2
  exit 1
fi

# Ping every server from the server_file
for server in $(cat ${server_file}); do
  echo "Pinging ${server}"
  ping -c 1 ${server} &> /dev/null

  # Check the status of the ping command
  if [[ "${?}" -ne 0 ]]; then
    echo "${server} down."
  else
    echo "${server} up."
  fi
done
