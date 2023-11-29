#!/bin/bash

# This scripts configures the docker swarm environment for a worker node.
# Worker IP can be set dynamically by DHCP. The only requirement is that DNS
# is configured to resolve the hostname of the manager node.

systemctl restart docker

# Force the node to leave the swarm if it is already part of it. 
docker swarm leave --force

# TODO: Obtain swarm token from manager node.