<div align="center">

# 🐳 Ubuntu 22 SSH Docker Container

[![Docker Hub](https://img.shields.ttestio/docker/pulls/polinux/ssh-ubuntu22.svg?style=for-the-badge&logo=docker&color=2496ed)](https://hub.docker.com/r/polinux/ssh-ubuntu22)
[![GitHub Stars](https://img.shields.io/github/stars/pozgo/docker-ssh-ubuntu22.svg?style=for-the-badge&logo=github&color=yellow)](https://github.com/pozgo/docker-ssh-ubuntu22)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)](LICENSE)
[![Ubuntu](https://img.shields.io/badge/ubuntu-22.04-orange.svg?style=for-the-badge&logo=ubuntu)](https://ubuntu.com/)

*A secure, feature-rich Docker container based on `polinux/ubuntu22-supervisor` that provides SSH access with configurable passwords, user creation, sudo privileges, and comprehensive logging.*

[🚀 Quick Start](#-quick-start) • [📖 Configuration](#configuration) • [🤝 Contributing](#-contributing) • [🐛 Issues](https://github.com/pozgo/docker-ssh-ubuntu22/issues)

</div>

---

## 📁 Project Structure

```
📦 docker-ssh-ubuntu22
├── 🐳 Dockerfile                           # Main container definition
├── 🐙 docker-compose.yml                   # Docker Compose configuration
├── 📖 README.md                           # This documentation
├── 📄 LICENSE                             # MIT License file
├── 📂 .github/                            # GitHub configuration
│   └── 🔄 workflows/
│       └── 🚀 docker.yml                 # CI/CD pipeline for Docker Hub
└── 📂 container-files/                    # Files copied to container
    ├── ⚙️  config/
    │   └── 🔧 init/
    │       ├── 🔑 10-init-set-root-pass.sh # Root password initialization script
    │       └── 👤 20-init-create-user.sh   # User creation and sudo setup script
    └── 📋 etc/
        └── 👥 supervisor.d/
            └── 🔐 sshd.conf               # SSH daemon supervisor config
```

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🔐 **SSH Server** | OpenSSH server pre-configured for secure root access |
| 👤 **User Creation** | Automatically create users with custom passwords via environment variables |
| 🔑 **Sudo Support** | Grant sudo privileges to created users with passwordless access |
| 👥 **Supervisor Management** | Robust process management using supervisor |
| 📝 **Password Logging** | All passwords logged to both stdout and persistent files |
| ⚙️ **Configurable Passwords** | Set custom passwords or auto-generate secure ones |
| 💾 **Persistent Logs** | All logs stored in `/data/logs/` for easy access |
| 🔄 **Auto-restart** | Services automatically restart on failure |
| 🐳 **Docker Hub Ready** | Available as pre-built image on Docker Hub |

## 🚀 Quick Start

### 📥 Pull from Docker Hub

```bash
# Pull the latest image
docker pull polinux/ssh-ubuntu22
```

### 🔨 Or Build Locally

```bash
# Clone and build
git clone https://github.com/pozgo/docker-ssh-ubuntu22.git
cd docker-ssh-ubuntu22
docker build -t polinux/ssh-ubuntu22 .
```

### 🔑 Run with Default Password

```bash
docker run -d -p 2222:22 --name ssh-container polinux/ssh-ubuntu22
# Default password: supersecurepass
```

### 🎯 Run with Custom Password

```bash
docker run -d -p 2222:22 --name ssh-container \
  -e ROOT_PASWD=mypassword \
  polinux/ssh-ubuntu22
```

### 🎲 Run with Auto-Generated Password

```bash
docker run -d -p 2222:22 --name ssh-container \
  -e ROOT_PASWD=password \
  polinux/ssh-ubuntu22
```

### 👤 Run with User Creation

```bash
docker run -d -p 2222:22 --name ssh-container \
  -e USER=developer \
  polinux/ssh-ubuntu22
```

### 🔑 Run with User + Sudo Privileges

```bash
docker run -d -p 2222:22 --name ssh-container \
  -e USER=developer \
  -e USER_IN_SUDO=true \
  polinux/ssh-ubuntu22
```

### 🐙 Using Docker Compose

```bash
# Run the default service
docker compose up -d

# Run with custom password profile
docker compose --profile custom up -d ssh-custom

# Run with auto-generated password profile
docker compose --profile auto up -d ssh-auto

# Run with user creation profile
docker compose --profile user up -d ssh-user

# Run with user + sudo privileges profile
docker compose --profile sudo up -d ssh-sudo

# Run development environment (user with sudo + auto password)
docker compose --profile dev up -d ssh-dev
```

## 🔌 Accessing the Container

### 🔐 SSH Access

```bash
# Connect via SSH as root (default password: supersecurepass)
ssh root@localhost -p 2222

# Connect via SSH as created user (password from logs)
ssh developer@localhost -p 2222

# Or with custom port mapping
ssh root@localhost -p <your-port>
ssh developer@localhost -p <your-port>
```

### 📋 Retrieve Passwords from Logs

```bash
# View container logs to see all passwords
docker logs ssh-container | grep "password"

# Access the root password log file directly
docker exec ssh-container cat /data/logs/root-password.log

# Access the user passwords log file directly
docker exec ssh-container cat /data/logs/user-passwords.log
```

## ⚙️ Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `ROOT_PASWD` | `supersecurepass` | Root user password. Set to `password` to auto-generate |
| `USER` | `""` | Username to create. If empty, no user is created |
| `USER_IN_SUDO` | `""` | Set to `true` to grant sudo privileges to created user |

### Ports

| Port | Description |
|------|-------------|
| 22 | SSH server port |

### Volumes

| Path | Description |
|------|-------------|
| `/data/logs/` | Log files including root and user password logs |
| `/data/conf/` | Configuration files |
| `/data/run/` | Runtime files (PIDs, sockets) |

## 🔑 Password Management

The container supports **multiple password and user configuration modes**:

### Root Password Modes

| Mode | Configuration | Description |
|------|---------------|-------------|
| 🔒 **Default** | No env variable | Uses `supersecurepass` |
| 🎯 **Custom** | `ROOT_PASWD=mypassword` | Set your own password |
| 🎲 **Auto-Generated** | `ROOT_PASWD=password` | Random 16-character password |

### User Creation Modes

| Mode | Configuration | Description |
|------|---------------|-------------|
| 🚫 **No User** | No `USER` variable | Only root user available |
| 👤 **Standard User** | `USER=username` | Create user with auto-generated password |
| 🔑 **Sudo User** | `USER=username USER_IN_SUDO=true` | Create user with sudo privileges |

> 📝 **Password Logging**: All passwords are logged to:
> - Container stdout (visible in `docker logs`)
> - `/data/logs/root-password.log` for root password
> - `/data/logs/user-passwords.log` for user passwords

## 💡 Examples

### 🛠️ Development Setup

```bash
# Pull and run for development
docker pull polinux/ssh-ubuntu22
docker run -d -p 2222:22 --name dev-ssh polinux/ssh-ubuntu22

# Get the password
docker logs dev-ssh | grep "Root password"

# Connect via SSH
ssh root@localhost -p 2222
```

### 🏭 Production with Custom Password

```bash
# Run with secure custom password
docker run -d -p 2222:22 --name prod-ssh \
  -e ROOT_PASWD=my-secure-password-123 \
  --restart unless-stopped \
  polinux/ssh-ubuntu22
```

### 👨‍💻 Development with User Account

```bash
# Run with dedicated developer user having sudo privileges
docker run -d -p 2222:22 --name dev-ssh \
  -e USER=developer \
  -e USER_IN_SUDO=true \
  --restart unless-stopped \
  polinux/ssh-ubuntu22

# Get user password from logs
docker logs dev-ssh | grep "User developer password"

# Connect as developer user
ssh developer@localhost -p 2222
```

### 💾 With Persistent Data Volume

```bash
# Run with persistent data volume
docker run -d -p 2222:22 --name ssh-persistent \
  -v ssh-data:/data \
  --restart unless-stopped \
  polinux/ssh-ubuntu22

# Access logs from volume
docker run --rm -v ssh-data:/data alpine \
  cat /data/logs/root-password.log
```

### 🐙 Docker Compose Example

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

## 🔒 Security Notes

> ⚠️ **Important Security Information**

| ⚠️ Warning | Description |
|------------|-------------|
| 🧪 **Development Use** | Container configured for development/testing purposes |
| 👤 **Root Login** | SSH permits root login for convenience |
| 🔑 **Production Keys** | Consider using SSH keys instead of passwords for production |
| 📝 **Password Logging** | All passwords are logged in plain text for convenience |
| 🔧 **Passwordless Sudo** | Created users with sudo privileges have passwordless access |
| 🔄 **Fresh Keys** | SSH host keys are regenerated on each build |

## 🔧 Troubleshooting

### 🚫 SSH Connection Refused

```bash
# Check if SSH service is running
docker exec ssh-container supervisorctl status sshd

# View SSH logs for errors
docker exec ssh-container cat /data/logs/sshd.log

# Restart SSH service if needed
docker exec ssh-container supervisorctl restart sshd
```

### 🔍 Cannot Find Password

```bash
# Check initialization logs for root password
docker logs ssh-container | grep SSH-INIT

# Check initialization logs for user creation
docker logs ssh-container | grep USER-INIT

# Check password log files directly
docker exec ssh-container cat /data/logs/root-password.log
docker exec ssh-container cat /data/logs/user-passwords.log

# List all log files
docker exec ssh-container ls -la /data/logs/
```

### 🔌 Port Already in Use

```bash
# Use different port mapping
docker run -d -p 2223:22 --name ssh-container polinux/ssh-ubuntu22
ssh root@localhost -p 2223

# Or find what's using the port
sudo lsof -i :2222
```

### 👤 User Creation Issues

```bash
# Check if user was created successfully
docker exec ssh-container id testuser

# Check sudo configuration for user
docker exec ssh-container cat /etc/sudoers.d/testuser

# Check user groups
docker exec ssh-container groups testuser

# Test sudo access
docker exec ssh-container su - testuser -c "sudo whoami"
```

## 🐳 Docker Hub

<div align="center">

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-polinux/ssh--ubuntu22-2496ed?style=for-the-badge&logo=docker)](https://hub.docker.com/r/polinux/ssh-ubuntu22)
[![GitHub](https://img.shields.io/badge/GitHub-pozgo/docker--ssh--ubuntu22-181717?style=for-the-badge&logo=github)](https://github.com/pozgo/docker-ssh-ubuntu22)

</div>

**Available Resources:**
- 🐳 **Docker Hub**: [polinux/ssh-ubuntu22](https://hub.docker.com/r/polinux/ssh-ubuntu22)
- 📂 **Source Code**: [github.com/pozgo/docker-ssh-ubuntu22](https://github.com/pozgo/docker-ssh-ubuntu22)
- 📋 **Issues**: [Report bugs & feature requests](https://github.com/pozgo/docker-ssh-ubuntu22/issues)

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. 🍴 **Fork** the repository on [GitHub](https://github.com/pozgo/docker-ssh-ubuntu22)
2. 🌿 **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. ✏️ **Make** your changes
4. 📝 **Commit** your changes (`git commit -m 'Add amazing feature'`)
5. 📤 **Push** to the branch (`git push origin feature/amazing-feature`)
6. 🔃 **Submit** a pull request

### 🏗️ Built With

This container is built on the excellent [polinux/ubuntu22-supervisor](https://github.com/pozgo/docker-supervisor-ubuntu22) base image.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**Copyright (c) 2025 Przemyslaw (Ozzy) Ozgo**

This project follows the same license as the base image [polinux/ubuntu22-supervisor](https://github.com/pozgo/docker-supervisor-ubuntu22).

<div align="center">

**Made with ❤️ by the Polinux Team**

⭐ Star us on GitHub if this project helped you!

</div>