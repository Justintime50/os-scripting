#!/bin/bash

EMAIL="$1"
PASSWORD="$2" # Use a Gmail app password, not your main password
CONFIG_FILEPATH="/etc/msmtprc"

sudo apt update
sudo apt install -y msmtp ca-certificates

sudo tee "$CONFIG_FILEPATH" <<EOF
# msmtp configuration for Gmail
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        ~/.msmtp.log

account        gmail
host           smtp.gmail.com
port           587
from           $EMAIL
user           $EMAIL
password       $PASSWORD

account default : gmail
EOF

chmod 600 "$CONFIG_FILEPATH"
sudo ln -s "$(which msmtp)" /usr/sbin/sendmail
echo "Subject: Test Email" | sendmail -v "$EMAIL"
echo "msmtp configuration complete. Check your inbox for the test email."
