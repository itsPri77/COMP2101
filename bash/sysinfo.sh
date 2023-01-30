#!/bin/bash

echo "FQDN: $(hostname)"
hostnamectl status
ipv4=$(hostname -I)
ipv6=$(ip addr | grep -w inet6 | awk '{print$2}' | grep -v ::1/128 )
echo "IP Addresses: $ipv4 $ipv6"
echo "Root Filesystem Status: "
df -h /
