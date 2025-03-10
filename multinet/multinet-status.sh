#!/bin/bash

# This script pings a list of servers and reports their status

SERVER_FILE='/vagrant/multinet/servers'

# Check if SERVER_FILE exists
if [[ ! -e "${SERVER_FILE}" ]]
then
  echo "Cannot open ${SERVER_FILE}" >&2
  exit 1
fi

# Ping every server from the SERVER_FILE
for SERVER in $(cat ${SERVER_FILE})
do
  echo "Pinging ${SERVER}"
  ping -c 1 ${SERVER} &> /dev/null

  # Check the status of the ping command
  if [[ "${?}" -ne 0 ]]
  then
    echo "${SERVER} down."
  else
    echo "${SERVER} up."
  fi
done
