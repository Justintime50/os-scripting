#!/bin/sh

main() {
    echo "Installing Teamviewer..."
    install_teamviewer
    echo "Teamviewer installed! Additional configuration may be required for the CLI implementation (headless)"
}

install_teamviewer() {
    wget https://download.teamviewer.com/download/linux/teamviewer-host_armhf.deb
    sudo dpkg -i teamviewer-host_armhf.deb
    sudo apt --fix-broken install
}

main
