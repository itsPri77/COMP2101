#!/bin/bash

fqdn=$(hostname -f)  #This displays the FQDN of the machine
os=$(lsb_release -ds)   #This will print the description of the distribution.
ip=$(ip route show | awk 'NR==1 {print$3}')    #This shows all the ip routes and awk filters it.
fs=$(df -h / | awk 'NR==2 {print $4}')         #This list the amount of disk space used and awk filters it to get just required value
cat << EOF

Report for $(hostname | cut -d '.' -f1 )
======================
FQDN: $fqdn
Operating System name and version: $os
IP Address: $ip
Root Filesystem Free Space: $fs
======================

EOF
