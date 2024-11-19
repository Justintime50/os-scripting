#!/bin/bash

# shellcheck disable=SC1091

# Store admin password
echo -n "Admin Password: "
read -rs PASSWORD

# Update packages
echo "Updating packages..."
echo "$PASSWORD" | sudo -S apt update && sudo -S apt upgrade -y

# Install Docker
echo "Installing Docker..."
echo "$PASSWORD" | sudo -S snap remove docker
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do echo "$PASSWORD" | sudo -S apt-get remove $pkg; done
echo "$PASSWORD" | sudo -S apt-get install ca-certificates curl
echo "$PASSWORD" | sudo -S install -m 0755 -d /etc/apt/keyrings
echo "$PASSWORD" | sudo -S curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
echo "$PASSWORD" | sudo -S chmod a+r /etc/apt/keyrings/docker.asc
# TODO: sudo -S doesn't get the password piped in here, is that necessary?
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    sudo -S tee /etc/apt/sources.list.d/docker.list >/dev/null
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Fix Docker permissions
echo "$PASSWORD" | sudo -S usermod -aG docker "$USER"

# Start Docker on boot
echo "$PASSWORD" | sudo -S systemctl enable docker
echo "$PASSWORD" | sudo -S systemctl start docker

# Setup firewall
echo "Setting up firewall..."
echo "$PASSWORD" | sudo -S ufw allow OpenSSH
echo "$PASSWORD" | sudo -S ufw allow 80
echo "$PASSWORD" | sudo -S ufw allow 443
echo "$PASSWORD" | sudo -S ufw enable

# Install other packages
echo "Installing other packages..."
echo "$PASSWORD" | sudo -S apt install -y \
    composer \
    fail2ban \
    just \
    neovim \
    python3-pip \
    python3-requests \
    python3-venv \
    zsh

# Install Homebrew
echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Disable IOMMU if running on a Mac
# https://www.reddit.com/r/linux_on_mac/comments/w3hisc/network_dropout_fix_for_linux_on_mac_with_kernel/
if echo "$PASSWORD" | sudo -S dmidecode -s system-manufacturer | grep -qi "apple"; then
    echo "Disabling IOMMU..."
    echo "$PASSWORD" | sudo -S sed -i 's/^GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="iommu.passthrough=1/' /etc/default/grub
    echo "$PASSWORD" | sudo -S update-grub2
fi

# Setup directories
echo "Setting up directories..."
mkdir -p git
mkdir -p /mnt/usb

# Change shell
echo "Changing shell..."
echo "$PASSWORD" | chsh -s /bin/zsh

# Generage SSH key
ssh-keygen -t rsa
echo "SSH key generated, please copy to GitHub or wherever it's needed."

# Cleanup and reboot
echo -e "Script complete.\nPlease check output before rebooting.\n\nPress <enter> to reboot."
read -rn 1
echo "Rebooting..."
sleep 5
history -c
echo "$PASSWORD" | sudo -S reboot
