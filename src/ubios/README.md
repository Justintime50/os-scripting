# UbiOS (Unifi) Scripting

The Unifi family and its associated products are pretty user friendly, but when they aren't, they REALLY aren't. Here are some troubleshooting tips and scripts to help out when things get rough.

## Usage

### See DHCP Lease Table (Router)

```bash
# SSH into your router
ssh root@192.168.1.1

# Run either of the following commands to see what is happening
cat /mnt/data/udapi-config/dnsmasq.lease
conntrack -L -n
```
