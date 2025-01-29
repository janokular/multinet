#!/bin/bash

# This script pings a list of servers and reports their status

SERVER_FILE='./servers'

# Check if SERVER_FILE exists and is a file
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
  if [[ "${?}" -ne 0 ]]
  then
    echo "${SERVER} down."
  else
    echo "${SERVER} up."
  fi
done
