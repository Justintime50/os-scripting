#!/bin/bash

# shellcheck disable=SC1091

# Store admin password
echo -n "Admin Password: "
read -rs PASSWORD

# Update packages
echo "$PASSWORD" | sudo apt update && sudo apt upgrade -y

# Install Docker
echo "$PASSWORD" | sudo snap remove docker
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do echo "$PASSWORD" | sudo apt-get remove $pkg; done
echo "$PASSWORD" | sudo apt-get install ca-certificates curl
echo "$PASSWORD" | sudo install -m 0755 -d /etc/apt/keyrings
echo "$PASSWORD" | sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
echo "$PASSWORD" | sudo chmod a+r /etc/apt/keyrings/docker.asc
# TODO: sudo doesn't get the password piped in here, is that necessary?
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
echo "$PASSWORD" | sudo apt-get update
echo "$PASSWORD" | sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Fix Docker permissions
echo "$PASSWORD" | sudo usermod -aG docker "$USER"
newgrp docker

# Start Docker on boot
echo "$PASSWORD" | sudo systemctl enable docker
echo "$PASSWORD" | sudo systemctl start docker

# Setup firewall
echo "$PASSWORD" | sudo ufw allow OpenSSH
echo "$PASSWORD" | sudo ufw allow 80
echo "$PASSWORD" | sudo ufw allow 443
echo "$PASSWORD" | sudo ufw enable

# Install other packages
echo "$PASSWORD" | sudo apt install -y \
    composer \
    fail2ban \
    neovim \
    python3-pip \
    python3-venv

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Disable IOMMU if running on a Mac
# https://www.reddit.com/r/linux_on_mac/comments/w3hisc/network_dropout_fix_for_linux_on_mac_with_kernel/
if echo "$PASSWORD" | sudo dmidecode -s system-manufacturer | grep -qi "apple"; then
    echo "$PASSWORD" | sudo sed -i \ 's/^GRUB_CMDLINE_LINUX=\"/GRUB_CMDLINE_LINUX=\"iommu.passthrough=1 /' \ /etc/default/grub
    echo "$PASSWORD" | sudo update-grub2
fi

# Cleanup and reboot
echo -e "Script complete.\nPlease check output before rebooting.\n\nPress <enter> to reboot."
read -rn 1
echo "Rebooting..."
sleep 5
history -c
echo "$PASSWORD" | sudo reboot
