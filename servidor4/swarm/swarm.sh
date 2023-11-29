#!/bin/bash

# This scripts configures the docker swarm environment for a manager node.
# Manager is expected to have only one network interface, eth0, with a fixed IP 
# address assigned by DHCP or set manually.

systemctl restart docker

# Clear swarm environment if exists.
docker swarm leave --force

docker swarm init --advertise-addr eth0

if [ $? -eq 0 ]; then
	echo WARNING! Swarm initialized successfully. 1>&2
else
	echo ERROR! Swarm initialization failed. Check the network configuration and retry. 1>&2
	exit 1
fi