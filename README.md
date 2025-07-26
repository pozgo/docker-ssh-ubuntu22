# Ubuntu 22 SSH Docker Container

[![Docker Hub](https://img.shields.io/docker/pulls/polinux/ssh-ubuntu22.svg)](https://hub.docker.com/r/polinux/ssh-ubuntu22)
[![GitHub](https://img.shields.io/github/stars/pozgo/docker-ssh-ubuntu22.svg?style=social)](https://github.com/pozgo/docker-ssh-ubuntu22)

A Docker container based on `polinux/ubuntu22-supervisor` that provides SSH access with configurable root password and comprehensive logging.

## Project Structure

```
├── Dockerfile                           # Main container definition
├── docker-compose.yml                   # Docker Compose configuration
├── README.md                           # This documentation
├── container-files/                    # Files copied to container
│   ├── config/
│   │   └── init/
│   │       └── 10-init-set-root-pass.sh # Password initialization script
│   └── etc/
│       └── supervisor.d/
│           └── sshd.conf               # SSH daemon supervisor config
```

## Features

- **SSH Server**: OpenSSH server configured for root access
- **Supervisor Management**: Uses supervisor to manage SSH daemon
- **Password Logging**: Root password is logged to both container output and persistent file
- **Configurable Password**: Root password can be set via environment variable or auto-generated
- **Persistent Logs**: Logs stored in `/data/logs/` for easy access

## Quick Start

### Pull from Docker Hub

```bash
docker pull polinux/ssh-ubuntu22
```

### Or Build Locally

```bash
git clone https://github.com/pozgo/docker-ssh-ubuntu22.git
cd docker-ssh-ubuntu22
docker build -t polinux/ssh-ubuntu22 .
```

### Run with Default Password

```bash
docker run -d -p 2222:22 --name ssh-container polinux/ssh-ubuntu22
```

### Run with Custom Password

```bash
docker run -d -p 2222:22 --name ssh-container -e ROOT_PASWD=mypassword polinux/ssh-ubuntu22
```

### Run with Auto-Generated Password

```bash
docker run -d -p 2222:22 --name ssh-container -e ROOT_PASWD=password polinux/ssh-ubuntu22
```

### Using Docker Compose

```bash
# Run the default service
docker-compose up -d

# Run with custom password
docker-compose --profile custom up -d ssh-custom

# Run with auto-generated password
docker-compose --profile auto up -d ssh-auto
```

## Accessing the Container

### SSH Access

```bash
# Connect via SSH (default password: supersecurepass)
ssh root@localhost -p 2222

# Or with custom port mapping
ssh root@localhost -p <your-port>
```

### Retrieve Root Password from Logs

```bash
# View container logs to see the root password
docker logs ssh-container

# Access the password log file
docker exec ssh-container cat /data/logs/root-password.log
```

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `ROOT_PASWD` | `supersecurepass` | Root user password. Set to `password` to auto-generate |

### Ports

| Port | Description |
|------|-------------|
| 22 | SSH server port |

### Volumes

| Path | Description |
|------|-------------|
| `/data/logs/` | Log files including root password log |
| `/data/conf/` | Configuration files |
| `/data/run/` | Runtime files (PIDs, sockets) |

## Password Management

The container supports three password modes:

1. **Default Password**: Uses `supersecurepass` if no environment variable is set
2. **Custom Password**: Set via `ROOT_PASWD` environment variable
3. **Auto-Generated**: Set `ROOT_PASWD=password` to generate a random 16-character password

The root password is always logged to:
- Container stdout (visible in `docker logs`)
- `/data/logs/root-password.log` file

## Examples

### Development Setup

```bash
# Pull and run for development
docker pull polinux/ssh-ubuntu22
docker run -d -p 2222:22 --name dev-ssh polinux/ssh-ubuntu22

# Get the password
docker logs dev-ssh | grep "Root password"

# Connect
ssh root@localhost -p 2222
```

### Production with Custom Password

```bash
# Run with secure custom password
docker run -d -p 2222:22 --name prod-ssh \
  -e ROOT_PASWD=my-secure-password-123 \
  polinux/ssh-ubuntu22
```

### With Persistent Data Volume

```bash
# Run with persistent data volume
docker run -d -p 2222:22 --name ssh-persistent \
  -v ssh-data:/data \
  polinux/ssh-ubuntu22

# Access logs from volume
docker run --rm -v ssh-data:/data alpine cat /data/logs/root-password.log
```

### Docker Compose Example

```bash
# Clone repository and use docker-compose
git clone https://github.com/pozgo/docker-ssh-ubuntu22.git
cd docker-ssh-ubuntu22

# Run default container
docker-compose up -d

# View logs to get password
docker-compose logs ssh-ubuntu22 | grep "Root password"

# Connect via SSH
ssh root@localhost -p 2222
```

## Security Notes

- The container is configured for development/testing purposes
- SSH is configured to permit root login
- Consider using SSH keys instead of passwords for production use
- The root password is logged in plain text for convenience
- All SSH host keys are regenerated on each build

## Troubleshooting

### SSH Connection Refused

```bash
# Check if SSH service is running
docker exec ssh-container supervisorctl status sshd

# View SSH logs
docker exec ssh-container cat /data/logs/sshd.log
```

### Cannot Find Password

```bash
# Check initialization logs
docker logs ssh-container | grep SSH-INIT

# Check password log file
docker exec ssh-container cat /data/logs/root-password.log
```

### Port Already in Use

```bash
# Use different port mapping
docker run -d -p 2223:22 --name ssh-container polinux/ssh-ubuntu22
ssh root@localhost -p 2223
```

## Docker Hub

This image is available on Docker Hub at:
- **Repository**: [polinux/ssh-ubuntu22](https://hub.docker.com/r/polinux/ssh-ubuntu22)
- **Source Code**: [github.com/pozgo/docker-ssh-ubuntu22](https://github.com/pozgo/docker-ssh-ubuntu22)

## Contributing

1. Fork the repository on [GitHub](https://github.com/pozgo/docker-ssh-ubuntu22)
2. Create a feature branch
3. Make your changes
4. Submit a pull request

This container is built on the excellent [polinux/ubuntu22-supervisor](https://github.com/pozgo/docker-supervisor-ubuntu22) base image.

## License

This project follows the same license as the base image.