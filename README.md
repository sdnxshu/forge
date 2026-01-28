# Forge

🐋 Automated Docker Engine installation script for Ubuntu systems

[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-blue.svg)](http://unlicense.org/) [![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%20%7C%2024.04%20%7C%2025.04%20%7C%2025.10-E95420?logo=ubuntu)](https://ubuntu.com/) [![Docker](https://img.shields.io/badge/Docker-Latest-2496ED?logo=docker)](https://www.docker.com/)

A comprehensive bash script that automates the installation of Docker Engine on Ubuntu systems, following official Docker documentation and best practices.

## Features

-   ✅ **Automatic OS Detection** - Validates Ubuntu version and architecture
-   ✅ **Clean Installation** - Removes conflicting packages automatically
-   ✅ **Official Repository** - Installs from Docker's official APT repository
-   ✅ **Complete Setup** - Includes Docker Engine, CLI, containerd, buildx, and compose
-   ✅ **Service Management** - Automatically starts and enables Docker service
-   ✅ **Verification** - Tests installation with hello-world container
-   ✅ **Error Handling** - Exits gracefully on failures with clear messages
-   ✅ **Colored Output** - Easy-to-read installation progress
-   ✅ **Post-Install Guidance** - Provides next steps for configuration

## Supported Systems

### Ubuntu Versions

-   Ubuntu 25.10 (Questing)
-   Ubuntu 25.04 (Plucky)
-   Ubuntu 24.04 LTS (Noble)
-   Ubuntu 22.04 LTS (Jammy)

### Architectures

-   x86_64 / amd64
-   armhf
-   arm64
-   s390x
-   ppc64le (ppc64el)

## Prerequisites

-   Ubuntu system (see supported versions above)
-   Root or sudo access
-   Internet connection
-   Minimum 2GB RAM recommended
-   20GB free disk space recommended

## Quick Start

### One-Line Installation

```bash
curl -fsSL https://raw.githubusercontent.com/sdnxshu/forge/main/forge.sh | sudo bash

```

### Manual Installation

```bash
# Clone the repository
git clone https://github.com/sdnxshu/forge.git

# Navigate to the directory
cd forge

# Make the script executable
chmod +x forge.sh

# Run the installation
sudo ./forge.sh

```

### Download and Run

```bash
# Download the script
wget https://raw.githubusercontent.com/sdnxshu/forge/main/forge.sh

# Make it executable
chmod +x forge.sh

# Run with sudo
sudo ./forge.sh

```

## What the Script Does

1.  **Pre-Installation Checks**
    
    -   Verifies root/sudo privileges
    -   Detects Ubuntu version and architecture
    -   Validates system compatibility
2.  **Cleanup**
    
    -   Removes conflicting packages (docker.io, podman-docker, etc.)
    -   Cleans up old Docker installations
3.  **Repository Setup**
    
    -   Installs prerequisites (ca-certificates, curl, gnupg)
    -   Adds Docker's official GPG key
    -   Configures Docker APT repository
4.  **Docker Installation**
    
    -   Installs docker-ce (Docker Engine)
    -   Installs docker-ce-cli (Docker CLI)
    -   Installs containerd.io (container runtime)
    -   Installs docker-buildx-plugin (build plugin)
    -   Installs docker-compose-plugin (compose plugin)
5.  **Service Configuration**
    
    -   Starts Docker service
    -   Enables Docker to start on boot
6.  **Verification**
    
    -   Checks Docker service status
    -   Runs hello-world container test
    -   Displays installation summary

## Post-Installation

### Running Docker Without Sudo

By default, Docker requires root privileges. To run Docker as a non-root user:

```bash
# Create docker group (if it doesn't exist)
sudo groupadd docker

# Add your user to the docker group
sudo usermod -aG docker $USER

# Log out and log back in, or run:
newgrp docker

# Verify you can run docker without sudo
docker run hello-world

```

### Verify Installation

```bash
# Check Docker version
docker --version

# Check Docker Compose version
docker compose version

# Check Docker service status
sudo systemctl status docker

# Run a test container
docker run hello-world

```

### Basic Docker Commands

```bash
# List running containers
docker ps

# List all containers
docker ps -a

# List images
docker images

# Pull an image
docker pull ubuntu

# Run a container
docker run -it ubuntu bash

# Stop a container
docker stop <container_id>

# Remove a container
docker rm <container_id>

```

## Firewall Considerations

⚠️ **Important Security Notice**

Docker bypasses UFW and firewalld rules when exposing container ports. Be aware of these limitations:

-   Exposed container ports bypass your firewall rules
-   Only `iptables-nft` and `iptables-legacy` are compatible with Docker
-   Firewall rules created with `nft` are not supported
-   Add custom rules to the `DOCKER-USER` chain

For more information, see [Docker and UFW documentation](https://docs.docker.com/engine/network/packet-filtering-firewalls/#docker-and-ufw).

## Troubleshooting

### Script Fails with "Not run as root"

```bash
# Always run with sudo
sudo ./forge.sh

```

### Docker Service Won't Start

```bash
# Check service status
sudo systemctl status docker

# View logs
sudo journalctl -u docker

# Manually start service
sudo systemctl start docker

```

### Permission Denied When Running Docker

```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Log out and back in, or run
newgrp docker

```

### Conflicting Packages

```bash
# Manually remove conflicting packages
sudo apt remove docker.io docker-compose docker-compose-v2 docker-doc podman-docker

# Run the script again
sudo ./forge.sh

```

### Ubuntu Version Not Supported

The script supports Ubuntu 22.04, 24.04, 25.04, and 25.10. For other versions:

-   Check [Docker's official documentation](https://docs.docker.com/engine/install/ubuntu/)
-   Consider using the convenience script at https://get.docker.com/

## Uninstalling Docker

If you need to remove Docker:

```bash
# Stop Docker service
sudo systemctl stop docker

# Remove Docker packages
sudo apt purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

# Remove Docker data (optional - this deletes all containers, images, volumes)
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# Remove repository and keys
sudo rm /etc/apt/sources.list.d/docker.sources
sudo rm /etc/apt/keyrings/docker.asc

# Remove Docker group
sudo groupdel docker

```

## Script Output Example

```
[INFO] Starting Docker installation process...
[INFO] Checking Ubuntu version...
[INFO] Detected Ubuntu 24.04 (noble)
[INFO] Ubuntu version 24.04 is supported
[INFO] Detected architecture: amd64
[INFO] Architecture amd64 is supported
[INFO] Removing old or conflicting Docker packages...
[INFO] Updating package index...
[INFO] Installing prerequisites...
[INFO] Setting up Docker GPG key...
[INFO] Adding Docker repository...
[INFO] Installing Docker Engine and components...
[INFO] Starting Docker service...
[INFO] Docker service is running
[INFO] Installed: Docker version 29.1.5, build 12345abc
[INFO] Running hello-world container to verify installation...
[INFO] Docker is working correctly!

==================================
[INFO] Docker installation completed successfully!
==================================

```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes:

1.  Fork the repository
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## License

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or distribute this software, either in source code form or as a compiled binary, for any purpose, commercial or non-commercial, and by any means.

See [UNLICENSE](https://github.com/sdnxshu/forge/blob/main/LICENSE) for more details.

## Acknowledgments

-   Based on [official Docker documentation](https://docs.docker.com/engine/install/ubuntu/)
-   Docker and the Docker logo are trademarks of Docker, Inc.

## Resources

-   [Docker Official Documentation](https://docs.docker.com/)
-   [Docker Hub](https://hub.docker.com/)
-   [Docker Engine Installation Guide](https://docs.docker.com/engine/install/ubuntu/)
-   [Post-installation Steps for Linux](https://docs.docker.com/engine/install/linux-postinstall/)
-   [Docker Compose Documentation](https://docs.docker.com/compose/)

## Support

-   📖 [Documentation](https://docs.docker.com/)
-   💬 [Docker Community Forums](https://forums.docker.com/)
-   🐛 [Issue Tracker](https://github.com/sdnxshu/forge/issues)

## Disclaimer

This script is provided as-is, without any warranty. Always review scripts before running them with sudo privileges. The script modifies system packages and configurations - use at your own risk.

----------

Made with ❤️ for the Docker community
