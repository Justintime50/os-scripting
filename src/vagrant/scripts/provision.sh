#!/bin/bash

# Prerequisites
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:kelleyk/emacs
sudo add-apt-repository ppa:deadsnakes/ppa

# Install packages
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y \
    apache2 \
    emacs27 \
    golang \
    libapache2-mod-php \
    nginx \
    nodejs \
    php \
    python3.9 \
    ruby-full

# This function will attempt to serve the /var/www directory over apache
# Alternatively you can place a site inside of /var/www/html
# if ! [ -L /var/www ]; then
#   rm -rf /var/www
#   ln -fs /vagrant /var/www
# fi
