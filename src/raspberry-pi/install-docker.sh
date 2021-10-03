#!/bin/sh

main() {
    echo "Installing Docker..."
    update_packages
    download_docker
    add_user_to_group
    validate_install
    echo "To complete the installation, run \"sudo reboot\""
}

update_packages() {
    # Upgrade Linux packages
    sudo apt-get update
    sudo apt-get upgrade
}

download_docker() {
    # Download Docker installer
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
}

add_user_to_group() {
    # Add your user (pi) to the docker group (disables the need to prepend each Docker command with sudo)
    sudo usermod -aG docker pi
}

validate_install() {
    # Ensure Docker is installed correctly
    docker version
}

main
