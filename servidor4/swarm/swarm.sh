#!/bin/bash

# This scripts configures the docker swarm environment for a manager node.
# Manager is expected to have only one network interface, eth0, with a fixed IP 
# address assigned by DHCP or set manually.

if [ "$EUID" -ne 0 ]
  then echo ERROR! Please run as root. 1>&2
  exit 1
fi

systemctl restart docker

# Clear swarm environment if exists.
docker swarm leave --force 2> /dev/null

docker swarm init --advertise-addr eth0

if [ $? -ne 0 ]; then
	echo ERROR! Swarm initialization failed. Check the network configuration and retry. 1>&2
	exit 1
fi

# Write token to a file to be used by the worker nodes.
docker swarm join-token -q worker > /home/admin/swarm_token

# Init services.
docker stack deploy -c /etc/wordpress/docker-compose.yml wordpress