#!/bin/bash

# This scripts configures the docker swarm environment for a manager node.
# Manager is expected to have only one network interface, eth0, with a fixed IP 
# address assigned by DHCP or set manually.

if [ "$EUID" -ne 0 ]
  then echo ERROR! Please run as root. 1>&2
  exit
fi

systemctl restart docker

# Clear swarm environment if exists.
docker swarm leave --force

docker swarm init --advertise-addr eth0

if [ $? -ne 0 ]; then
	echo ERROR! Swarm initialization failed. Check the network configuration and retry. 1>&2
	exit 1
fi