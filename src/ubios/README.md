# UbiOS (Unifi) Scripting

The Unifi family and its associated products are pretty user friendly, but when they aren't, they REALLY aren't. Here are some troubleshooting tips and scripts to help out when things get rough.

## Setup

```bash
# Add SSH keys to device (note, these get wiped out on each device reboot)
ssh-copy-id root@192.168.1.1

# SSH into your router
ssh root@192.168.1.1
```

## Usage

### Download Unifi Config Backups

```bash
# Downloads all of your Unifi config backups (see file for more info)
download_config_backups.sh ~/my_dir my_username 172.168.0.1 30
```

### See DHCP Lease Table (Router)

```bash
# Run either of the following commands to see what is happening
cat /mnt/data/udapi-config/dnsmasq.lease
conntrack -L -n
```

### Logs

```bash
# Server Logs
cat /mnt/data/unifi-os/unifi/logs/server.log

# System Logs
cat /mnt/data/unifi-os/unifi-core/logs/system.log
```

### Manual Upgrades

```bash
ubnt-upgrade https://fw-download.ubnt.com/<insertfilepathhere>.bin
```
