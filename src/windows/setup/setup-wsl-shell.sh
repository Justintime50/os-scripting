#!/bin/bash

main() {
    echo "Installing ZSH and Emacs..."
    sudo apt-get install zsh
    sudo add-apt-repository ppa:kelleyk/emacs
    sudo apt-get install emacs27
}

main
