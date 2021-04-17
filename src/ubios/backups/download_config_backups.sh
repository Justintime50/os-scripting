#!/bin/bash

# Download all your Unifi config backups via SCP
# Requires you to have saved your SSH keys to the `authorized_keys` file on the Unifi device
# These keys will get wiped out on every reboot of the device
# Usage: download_config_backups.sh ~/my_dir my_username 172.168.0.1 30

DIR=${1:-"$HOME/Downloads/unifi_backups"}
NETWORK_DIR="$DIR/network"
PROTECT_DIR="$DIR/protect"
ACCESS_DIR="$DIR/access"
TALK_DIR="$DIR/talk"
USERNAME=${2:-"root"}
IP=${3:-"192.168.1.1"}
BACKUP_LIFE=${4:-"90"}

main() {
    echo "Backing up Unifi configs..."
    create_directory
    backup_network_config
    backup_protect_config
    # backup_access_config
    # backup_talk_config
    cleanup_backups
    echo "Script complete"
}

create_directory() {
    mkdir -p "$DIR"
    mkdir -p "$NETWORK_DIR"
    mkdir -p "$PROTECT_DIR"
    # mkdir -p "$ACCESS_DIR"
    # mkdir -p "$TALK_DIR"
}

backup_network_config() {
    # Unifi Network
    scp "$USERNAME"@"$IP":/mnt/data/unifi-os/unifi/data/backup/autobackup/*.unf "$NETWORK_DIR"
}

backup_protect_config() {
    # Unifi Protect
    scp "$USERNAME"@"$IP":/srv/unifi-protect/backups/*.zip "$PROTECT_DIR"
}

backup_access_config() {
    # Unifi Access
    scp "$USERNAME"@"$IP":/srv/unifi-access/backups/*.zip "$ACCESS_DIR"
}

backup_talk_config() {
    # Unifi Talk
    scp "$USERNAME"@"$IP":/srv/unifi-talk/backups/*.zip "$TALK_DIR"
}

cleanup_backups() {
    find "$DIR" -type f -mindepth 1 -mtime +"$BACKUP_LIFE" -delete
}

main
