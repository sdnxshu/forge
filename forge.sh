#!/bin/bash

#################################################################################
# Docker Installation Script for Ubuntu
# 
# This script automates the installation of Docker Engine on Ubuntu systems
# Supports: Ubuntu 22.04 (Jammy), 24.04 (Noble), 25.04 (Plucky), 25.10 (Questing)
# Architectures: x86_64/amd64, armhf, arm64, s390x, ppc64le
#
# Usage: sudo bash install-docker.sh
#################################################################################

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run as root or with sudo"
   exit 1
fi

print_info "Starting Docker installation process..."

# Check Ubuntu version
print_info "Checking Ubuntu version..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VER=$VERSION_ID
    CODENAME=$UBUNTU_CODENAME
    
    if [ "$OS" != "ubuntu" ]; then
        print_error "This script is designed for Ubuntu only. Detected: $OS"
        exit 1
    fi
    
    print_info "Detected Ubuntu $VER ($CODENAME)"
else
    print_error "Cannot detect OS version"
    exit 1
fi

# Verify supported Ubuntu version
case $VER in
    22.04|24.04|25.04|25.10)
        print_info "Ubuntu version $VER is supported"
        ;;
    *)
        print_warning "Ubuntu $VER may not be officially supported. Supported versions: 22.04, 24.04, 25.04, 25.10"
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
        ;;
esac

# Check architecture
ARCH=$(dpkg --print-architecture)
print_info "Detected architecture: $ARCH"

case $ARCH in
    amd64|armhf|arm64|s390x|ppc64el)
        print_info "Architecture $ARCH is supported"
        ;;
    *)
        print_error "Architecture $ARCH is not supported by Docker Engine"
        exit 1
        ;;
esac

# Uninstall old/conflicting packages
print_info "Removing old or conflicting Docker packages..."
apt remove -y docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc 2>/dev/null || true

print_info "Removing conflicting packages (if any)..."
for pkg in docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc; do
    if dpkg -l | grep -q "^ii  $pkg "; then
        print_warning "Removing $pkg..."
        apt purge -y $pkg
    fi
done

# Update package index
print_info "Updating package index..."
apt update

# Install prerequisites
print_info "Installing prerequisites..."
apt install -y ca-certificates curl gnupg lsb-release

# Create keyrings directory
print_info "Setting up Docker GPG key..."
install -m 0755 -d /etc/apt/keyrings

# Download Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Set up the Docker repository
print_info "Adding Docker repository..."
cat > /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: ${UBUNTU_CODENAME:-$VERSION_CODENAME}
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# Update package index with Docker repository
print_info "Updating package index with Docker repository..."
apt update

# Install Docker Engine
print_info "Installing Docker Engine and components..."
apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Start Docker service
print_info "Starting Docker service..."
systemctl start docker
systemctl enable docker

# Verify Docker installation
print_info "Verifying Docker installation..."
if systemctl is-active --quiet docker; then
    print_info "Docker service is running"
else
    print_error "Docker service is not running"
    exit 1
fi

# Check Docker version
DOCKER_VERSION=$(docker --version)
print_info "Installed: $DOCKER_VERSION"

# Run hello-world container to verify
print_info "Running hello-world container to verify installation..."
if docker run hello-world > /dev/null 2>&1; then
    print_info "Docker is working correctly!"
else
    print_error "Docker installation verification failed"
    exit 1
fi

# Post-installation information
echo ""
print_info "=================================="
print_info "Docker installation completed successfully!"
print_info "=================================="
echo ""
print_info "Docker version: $DOCKER_VERSION"
print_info "Docker service status: $(systemctl is-active docker)"
echo ""
print_warning "IMPORTANT: Currently, only root can run Docker commands."
echo ""
print_info "To allow non-root users to run Docker commands:"
print_info "  1. Create docker group (if not exists): sudo groupadd docker"
print_info "  2. Add your user to the docker group: sudo usermod -aG docker \$USER"
print_info "  3. Log out and log back in for changes to take effect"
print_info "  4. Verify: docker run hello-world"
echo ""
print_info "For more information, visit:"
print_info "  - Post-installation steps: https://docs.docker.com/engine/install/linux-postinstall/"
print_info "  - Docker documentation: https://docs.docker.com/"
echo ""
print_warning "Firewall Notice:"
print_info "  Docker bypasses ufw/firewalld rules when exposing container ports."
print_info "  Only iptables-nft and iptables-legacy are compatible with Docker."
print_info "  Add custom rules to the DOCKER-USER chain."
echo ""

exit 0
