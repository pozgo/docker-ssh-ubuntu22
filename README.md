# Ubuntu 22 SSH Docker Container

A Docker container based on `polinux/ubuntu22-supervisor` that provides SSH access with configurable root password and comprehensive logging.

## Features

- **SSH Server**: OpenSSH server configured for root access
- **Supervisor Management**: Uses supervisor to manage SSH daemon
- **Password Logging**: Root password is logged to both container output and persistent file
- **Configurable Password**: Root password can be set via environment variable or auto-generated
- **Persistent Logs**: Logs stored in `/data/logs/` for easy access

## Quick Start

### Build the Image

```bash
docker build -t ubuntu22-ssh .
```

### Run with Default Password

```bash
docker run -d -p 2222:22 --name ssh-container ubuntu22-ssh
```

### Run with Custom Password

```bash
docker run -d -p 2222:22 --name ssh-container -e ROOT_PASWD=mypassword ubuntu22-ssh
```

### Run with Auto-Generated Password

```bash
docker run -d -p 2222:22 --name ssh-container -e ROOT_PASWD=password ubuntu22-ssh
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
# Build and run for development
docker build -t ubuntu22-ssh .
docker run -d -p 2222:22 --name dev-ssh ubuntu22-ssh

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
  ubuntu22-ssh
```

### With Persistent Data Volume

```bash
# Run with persistent data volume
docker run -d -p 2222:22 --name ssh-persistent \
  -v ssh-data:/data \
  ubuntu22-ssh

# Access logs from volume
docker run --rm -v ssh-data:/data alpine cat /data/logs/root-password.log
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
docker run -d -p 2223:22 --name ssh-container ubuntu22-ssh
ssh root@localhost -p 2223
```

## Contributing

This container is built on the excellent [polinux/ubuntu22-supervisor](https://github.com/pozgo/docker-supervisor-ubuntu22) base image.

## License

This project follows the same license as the base image.