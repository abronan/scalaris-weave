#!/bin/bash

if [ -z "$JOIN_IP" ]; then
  echo "error - you must set the address to join"
  exit 1
fi

if [ -z "$LISTEN_ADDRESS" ]; then
  echo "error - you must set the listen address"
  exit 1
fi

# Replace points by commas on IP addresses
#
JOIN_IP_COMMA=`echo $JOIN_IP | tr '.' ','`
LISTEN_ADDRESS_COMMA=`echo $LISTEN_ADDRESS | tr '.' ','`

# Fill in the minimal configuration for Scalaris
#
echo "
{listen_ip , {$LISTEN_ADDRESS_COMMA}}.
{mgmt_server, {{$JOIN_IP_COMMA},14195,mgmt_server}}.
{known_hosts, [{{$JOIN_IP_COMMA},14195, service_per_vm}
]}.
" >> /etc/scalaris/scalaris.local.cfg

# Debug print the config file
#
echo Scalaris Config:
cat /etc/scalaris/scalaris.local.cfg

# Generate random uuid
#
export UUID=$(cat /proc/sys/kernel/random/uuid)

# Manage Scalaris ring
#
if [ "$JOIN_IP" == "$LISTEN_ADDRESS" ]; then
  # We are the first node, we create the ring
  scalarisctl -m -d -n $UUID@$LISTEN_ADDRESS -p 14195 -y 8000 -s -f start
else
  # Join the existing ring
  scalarisctl -d -n $UUID@$LISTEN_ADDRESS -p 14195 -y 8000 -s start
fi
