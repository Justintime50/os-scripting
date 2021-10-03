#!/bin/sh

main() {
    echo "Installing docker-compose..."
    install_docker_compose
    echo "docker-compose installed!"
}

install_docker_compose() {
    sudo apt-get install -y python3-pip libffi-dev
    sudo pip3 install docker-compose
}

main
