#!/bin/bash

# Download all your Unifi backups via SCP
# Usage: download_backups.sh ~/my_dir my_username 172.168.0.1

DIR=${1:-"$HOME/Downloads/unifi_backups"}
USERNAME=${2:-"root"}
IP=${3:-"192.168.1.1"}

main() {
    echo "Backing up Unifi configs..."
    create_directory
    backup_configs
    echo "Script complete"
}

create_directory() {
    mkdir -p "$DIR"
}

backup_configs() {
    scp "$USERNAME"@"$IP":/mnt/data/unifi-os/unifi/data/backup/autobackup/*.unf "$DIR"
}

main
