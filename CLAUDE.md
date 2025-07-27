# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Docker container project that creates an Ubuntu 22 image with SSH access. It builds on top of the `polinux/ubuntu22-supervisor` base image and configures SSH daemon with supervisor. The container provides reliable SSH access with comprehensive password logging for development and testing purposes.

## Architecture

The container setup consists of:

- **Dockerfile**: Main container definition that installs openssh-server, sudo, and pwgen, generates host keys, and configures SSH daemon
- **container-files/**: Contains files to be copied into the container
  - **config/init/10-init-set-root-pass.sh**: Initialization script that sets root password and logs it to both stdout and file
  - **config/init/20-init-create-user.sh**: Initialization script that creates users and configures sudo privileges based on environment variables
  - **etc/supervisor.d/sshd.conf**: Supervisor configuration for managing the SSH daemon process

## Development Commands

This is a Docker container project with no traditional build system. Key operations:

```bash
# Build the Docker image
docker build -t ubuntu22-ssh .

# Run with default password (supersecurepass)
docker run -d -p 2222:22 --name ssh-container ubuntu22-ssh

# Run with custom password
docker run -d -p 2222:22 --name ssh-container -e ROOT_PASWD=mypassword ubuntu22-ssh

# Run with auto-generated password
docker run -d -p 2222:22 --name ssh-container -e ROOT_PASWD=password ubuntu22-ssh

# Run with user creation
docker run -d -p 2222:22 --name ssh-container -e USER=developer ubuntu22-ssh

# Run with user creation and sudo privileges
docker run -d -p 2222:22 --name ssh-container -e USER=developer -e USER_IN_SUDO=true ubuntu22-ssh

# Access the container via SSH (root)
ssh root@localhost -p 2222

# Access the container via SSH (created user)
ssh developer@localhost -p 2222

# Retrieve passwords from logs
docker logs ssh-container | grep "password"
docker exec ssh-container cat /data/logs/root-password.log
docker exec ssh-container cat /data/logs/user-passwords.log
```

## Key Configuration

- **Root password**: Set via `ROOT_PASWD` environment variable (default: `supersecurepass`)
  - Set to `password` to auto-generate a random 16-character password
- **User creation**: Set via `USER` environment variable to create a new user with auto-generated password
- **Sudo privileges**: Set `USER_IN_SUDO=true` to grant sudo privileges to the created user (requires `USER` to be set)
- **SSH port**: Container exposes port 22
- **SSH configuration**: Permits root login, disables DNS lookups and challenge-response authentication
- **Process management**: Uses supervisor to manage SSH daemon
- **Logging**: Passwords logged to both container stdout and respective log files:
  - Root password: `/data/logs/root-password.log`
  - User passwords: `/data/logs/user-passwords.log`

## Testing

The container has been tested and verified to work correctly:
- SSH connectivity works with both default and custom passwords
- Password logging functions properly in both stdout and log file
- Supervisor correctly manages the SSH daemon
- Auto-generated passwords work as expected

## Security Notes

The container generates fresh SSH host keys on build and configures SSH for development/testing purposes with permissive settings. The root password is configurable through environment variables and is logged in plain text for convenience. Consider using SSH keys instead of passwords for production use.