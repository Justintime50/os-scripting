#!/bin/sh

main() {
    echo "Installing SSH..."
    sudo apt-get purge openssh-server
    sudo apt-get install openssh-server

    echo "Enabling SSH on boot and turning it on..."
    systemctl enable sshd
    systemctl start sshd
}
