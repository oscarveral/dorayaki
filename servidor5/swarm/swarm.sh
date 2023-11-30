#!/bin/bash

# This scripts configures the docker swarm environment for a worker node.
# Worker IP can be set dynamically by DHCP. The only requirement is that DNS
# is configured to resolve the hostname of the manager node.

if [ "$EUID" -ne 0 ]
  then echo ERROR! Please run as root. 1>&2
  exit
fi

systemctl restart docker

# Force the node to leave the swarm if it is already part of it. 
docker swarm leave --force

# TODO: Obtain swarm token from manager node.