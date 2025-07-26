#!/bin/bash
set -euo pipefail
export TERM=xterm

# Bash Colors
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
white=`tput setaf 7`
bold=`tput bold`
reset=`tput sgr0`

# Logging Function
log() {
  if [[ "$@" ]]; then echo "${bold}${green}[SSH-INIT `date +'%T'`]${reset} $@";
  else echo; fi
}

# Generate password for root if set to 'password'
if [ "${ROOT_PASWD:-supersecurepass}" == "password" ]; then
    ROOT_PASWD=$(pwgen -c -n -1 16)
    log "Generated random password for root user"
fi

# Set root password
echo "root:${ROOT_PASWD}" | chpasswd

# Log the password to container logs and file
log "Root password set to: ${white}${bold}${ROOT_PASWD}${reset}"
echo "[$(date +'%Y-%m-%d %H:%M:%S')] Root password: ${ROOT_PASWD}" >> /data/logs/root-password.log

log "SSH initialization completed"