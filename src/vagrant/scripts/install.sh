#!/bin/bash

# Installs dependencies and the Devvm
main() {
    echo "Installing dependencies..."
    install_dependencies
    echo "Dependencies installed!"
    setup_vagrant
    echo "Devvm now running! Use \"vagrant ssh\" to connect."
}

install_dependencies() {
    brew install --cask vagrant
    brew install --cask virtualbox
}

setup_vagrant() {
    cd src || exit 1
    vagrant up
}

main
