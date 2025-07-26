FROM polinux/ubuntu22-supervisor:latest

ENV ROOT_PASWD=supersecurepass

RUN \
    apt update && \
    apt install -y openssh-server pwgen && \
    rm -f /etc/ssh/ssh_host_* && \
    ssh-keygen -A && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config && \
    sed -i 's/#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config && \
    mkdir -p /var/run/sshd && \
    chmod 0755 /var/run/sshd && \
    mkdir -p /data/logs

COPY container-files /

EXPOSE 22