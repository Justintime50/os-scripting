#!/bin/bash

# shellcheck disable=SC1091

# Update packages
sudo apt update && sudo apt upgrade -y

# Install Docker
sudo snap remove docker
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Fix Docker permissions
sudo usermod -aG docker "$USER"
newgrp docker

# Start Docker on boot
sudo systemctl enable docker
sudo systemctl start docker

# Setup firewall
sudo ufw allow OpenSSH
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable

# Install other packages
sudo apt install -y fail2ban \
    neovim \
    python3-venv \
    python3-pip

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Disable IOMMU if running on a Mac
# https://www.reddit.com/r/linux_on_mac/comments/w3hisc/network_dropout_fix_for_linux_on_mac_with_kernel/
if sudo dmidecode -s system-manufacturer | grep -qi "apple"; then
    sudo sed -i \ 's/^GRUB_CMDLINE_LINUX=\"/GRUB_CMDLINE_LINUX=\"iommu.passthrough=1 /' \ /etc/default/grub
    sudo update-grub2
fi

sudo reboot
