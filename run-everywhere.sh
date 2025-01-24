#!/bin/bash

# This script allows exection of command on the 

# List of servers, one per line.
SERVER_FILE='/vagrant/servers'

# Options for the ssh command.
SSH_OPTIONS='-o ConnectTimeout=2'

# Display usage instructions.
usage() {
  echo "Usage: ${0} [-nsv] [-f FILE] COMMAND"
  echo 'Executes COMMAND as a single command on every server.'
  echo -e "-f FILE\tUse FILE for the list of servers. Default: ${SERVER_FILE}."
  echo -e '-n\tDry run mode. Display the COMMAND that would been executed and exit.'
  echo -e '-s\tExecute the COMMAND using sudo on the remote server.'
  echo -e '-v\tVerbose mode. Displays the server name before executing COMMAND.'
  exit 1
}

# Check if verbose mode is on and display message.
verbose() {
  local MESSAGE="${@}"
  if [[ ${VERBOSE_MODE} = 'true' ]]
  then
    echo "${MESSAGE}"
  fi
}

# Check if script is not run with sudo/root privliges.
if [[ "${UID}" -eq 0 ]] 
then
  echo 'Do not execute this script as root. Use the -s option instead.' >&2
  usage
fi

# Check options provided by the user.
while getopts f:nsv OPTION
do
  case ${OPTION} in
    f) SERVER_FILE=${OPTARG} ;;
    n) DRY_RUN_MODE='true' ;;
    s) SUDO_MODE=' sudo' ;;
    v) VERBOSE_MODE='true' ;;
    ?) usage ;;
  esac
done

# Remove the options while leaving the remaining arguments.
shift "$(( OPTIND - 1 ))"

# Check if user provided at leas one argument to the script.
if [[ "${#}" -lt 1 ]]
then
  usage
fi

# Anything that remains on the command line is to be treated as a single command.
COMMAND="${@}"

# Later assing an exit status of an SSH_COMMAND
EXIT_STATUS='0'

# Make sure the SERVER_LIST file exists.
if [[ ! -e "${SERVER_FILE}" ]]
then
  echo "Cannot open ${SERVER_FILE}" >&2
  exit 1
fi

# Loop through the SERVER_LIST
for SERVER in $(cat ${SERVER_FILE})
do
  verbose "${SERVER}"

  SSH_COMMAND="ssh ${SSH_OPTIONS} ${SERVER}${SUDO_MODE} ${COMMAND}"

  # If it's a dry run, don't execute anything, just echo it.
  if  [[ ${DRY_RUN_MODE} = 'true' ]]
  then
    echo "DRY RUN: ${SSH_COMMAND}"
  else
    ${SSH_COMMAND}
    EXIT_STATUS="${?}"

    # Capture any non-zero exit status from the SSH_COMMAND and report to the user.
    if [[ "${EXIT_STATUS}" -ne 0 ]]
    then
      echo "Execution on ${SERVER} failed."
    fi
  fi
done

exit ${EXIT_STATUS}