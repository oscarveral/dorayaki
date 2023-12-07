#!/bin/bash

# This scripts configures the docker swarm environment for a worker node.
# Worker IP can be set dynamically by DHCP. The only requirement is that DNS
# is configured to resolve the hostname of the manager node.

if [ "$EUID" -ne 0 ]
  then echo ERROR! Please run as root. 1>&2
  exit 1
fi

systemctl restart docker

# Force the node to leave the swarm if it is already part of it. 
docker swarm leave --force

# Get the token from the manager node.
sshpass -p "admin" scp admin@swarm.dorayaki.org:/home/admin/swarm_token ./swarm_token
TOKEN=$(cat swarm_token)
rm swarm_token 2> /dev/null

# Join the swarm.
docker swarm join --token $TOKEN swarm.dorayaki.org