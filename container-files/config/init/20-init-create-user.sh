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
  if [[ "$@" ]]; then echo "${bold}${green}[USER-INIT `date +'%T'`]${reset} $@";
  else echo; fi
}

# Check if USER environment variable is set and not empty
if [ -n "${USER:-}" ]; then
    log "Creating user: ${white}${bold}${USER}${reset}"
    
    # Create user with home directory
    useradd -m -s /bin/bash "${USER}"
    
    # Generate password for user if not provided
    USER_PASSWORD=$(pwgen -c -n -1 16)
    echo "${USER}:${USER_PASSWORD}" | chpasswd
    
    # Log the user password
    log "User password set to: ${white}${bold}${USER_PASSWORD}${reset}"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] User ${USER} password: ${USER_PASSWORD}" >> /data/logs/user-passwords.log
    
    # Check if user should be added to sudo group
    if [ -n "${USER_IN_SUDO:-}" ] && [ "${USER_IN_SUDO}" == "true" ]; then
        log "Adding user ${white}${bold}${USER}${reset} to sudo group"
        usermod -aG sudo "${USER}"
        
        # Configure passwordless sudo for the user
        echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${USER}
        chmod 0440 /etc/sudoers.d/${USER}
        
        log "User ${white}${bold}${USER}${reset} granted sudo privileges"
    fi
    
    log "User creation completed for: ${white}${bold}${USER}${reset}"
else
    log "No USER environment variable set, skipping user creation"
fi