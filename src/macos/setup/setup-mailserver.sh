#!/bin/bash

# This script sets up a Gmail web server on macOS
# Docs: https://gist.github.com/Justintime50/6053e4657dd6d9ccec6cda20ec5389a5

main() {
    echo "Setting up mail server..."

    # Install postfix on Linux (included on macOS)
    if [[ "$(uname)" == "Linux" ]]; then
        sudo apt update && sudo apt install postfix
    fi

    # Setup mail credentials
    sudo mkdir -p /etc/postfix
    echo "smtp.gmail.com:587 EMAIL:PASSWORD" | sudo tee /etc/postfix/sasl_passwd >/dev/null
    echo "Please fill in the email and password in /etc/postfix/sasl_passwd, press any button to continue once this is done"
    read -rn 1

    # Make a backup of the config file
    sudo cp /etc/postfix/main.cf /etc/postfix/main.cf.bak

    # Write new config options to file
    sudo tee -a /etc/postfix/main.cf >/dev/null <<EOT
relayhost = smtp.gmail.com:587
smtp_sasl_mechanism_filter = plain
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_use_tls = yes
# smtp_tls_security_level = encrypt
# tls_random_source = dev:/dev/urandom
EOT

    # Setup DB file and secure it (must be run only after the email/password have been set in `/etc/postfix/sasl_passwd`)
    sudo postmap /etc/postfix/sasl_passwd
    sudo chown root: /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
    sudo chmod 600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db

    # Restart the mail server
    if [[ "$(uname)" == "Darwin" ]]; then
        sudo launchctl stop org.postfix.master
        sudo launchctl start org.postfix.master
    elif [[ "$(uname)" == "Linux" ]]; then
        sudo systemctl restart postfix
    fi

    echo "Mail server configured!"
}

main
