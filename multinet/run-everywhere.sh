#!/bin/bash

# This script allows exection of command on the list of servers

# List of servers, one per line
server_file='/vagrant/multinet/servers'

# options for the ssh command
ssh_options='-o ConnectTimeout=2'

usage() {
  echo "Usage: ${0} [-nsv] [-f FILE] COMMAND"
  echo 'Executes command as a single command on every server.'
  echo -e "-f FILE\tUse FILE for the list of servers. Default: ${server_file}."
  echo -e '-n\tDry run mode. Display the command that would been executed and exit.'
  echo -e '-s\tExecute the command using sudo on the remote server.'
  echo -e '-v\tVerbose mode. Displays the server name before executing command.'
  exit 1
}

# Check if verbose mode is on and display message
verbose() {
  local message="${@}"
  if [[ ${verbose_mode} = 'true' ]]; then
    echo "${message}"
  fi
}

# Check if script is not run with sudo/root privileges
if [[ "${UID}" -eq 0 ]]; then
  echo 'Do not execute this script as root. Use the -s option instead.' >&2
  usage
fi

# Check options provided by the user
while getopts f:nsv option; do
  case ${option} in
    f) server_file=${OPTARG} ;;
    n) dry_run_mode='true' ;;
    s) sudo_mode=' sudo' ;;
    v) verbose_mode='true' ;;
    ?) usage ;;
  esac
done

# Remove the options while leaving the remaining arguments
shift "$(( OPTIND - 1 ))"

# Check if user provided at least one argument to the script
if [[ "${#}" -lt 1 ]]; then
  usage
fi

# Anything that remains on the command line is to be treated as a single command
command="${@}"

# Later assing an exit status of an ssh_command
exit_status='0'

# Make sure the server_file file exists
if [[ ! -e "${server_file}" ]]; then
  echo "Cannot open ${server_file}" >&2
  exit 1
fi

# Loop through the server_file
for server in $(cat ${server_file}); do
  verbose "${server}"

  ssh_command="ssh ${ssh_options} ${server}${sudo_mode} ${command}"

  # If it's a dry run, don't execute anything, just echo it
  if  [[ ${dry_run_mode} = 'true' ]]; then
    echo "DRY RUN: ${ssh_command}"
  else
    ${ssh_command}
    exit_status="${?}"

    # Capture any non-zero exit status from the ssh_command and report to the user
    if [[ "${exit_status}" -ne 0 ]]; then
      echo "Execution on ${server} failed."
    fi
  fi
done

exit ${exit_status}
