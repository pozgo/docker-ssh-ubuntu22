FROM polinux/ubuntu22-supervisor:latest

ENV ROOT_PASWD=supersecurepass
ENV USER=""
ENV USER_PASWD=""
ENV USER_IN_SUDO=""

# Install packages with retry logic and proper cleanup
RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    \
    # Update package lists with retry
    apt-get update || (sleep 5 && apt-get update); \
    \
    # Install packages
    apt-get install -y --no-install-recommends \
        openssh-server \
        pwgen \
        sudo \
        ca-certificates; \
    \
    # Clean up to reduce image size
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archives/*; \
    \
    # Generate SSH host keys
    rm -f /etc/ssh/ssh_host_*; \
    ssh-keygen -A; \
    \
    # Configure SSH for remote access
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config; \
    sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config; \
    sed -i 's/#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config; \
    \
    # Create required directories
    mkdir -p /var/run/sshd /data/logs; \
    chmod 0755 /var/run/sshd

COPY container-files /

# Set execution permissions for init scripts
RUN chmod +x /config/init/*.sh

EXPOSE 22