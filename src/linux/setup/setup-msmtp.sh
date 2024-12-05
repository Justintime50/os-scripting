#!/bin/bash

EMAIL="$1"
PASSWORD="$2" # Use a Gmail app password, not your main password
CONFIG_FILE="$HOME/.msmtprc"

sudo apt update
sudo apt install -y msmtp ca-certificates

cat <<EOF >"$CONFIG_FILE"
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

chmod 600 "$CONFIG_FILE"

echo -e "Subject: Test Email\n\nThis is a test email." | msmtp --debug --from=default -t "$EMAIL"
echo "msmtp configuration complete. Check your inbox for the test email."
