#!/bin/bash

# This scripts configures the docker swarm environment for a manager node.
# Manager is expected to have only one network interface, eth0, with a fixed IP 
# address assigned by DHCP or set manually.

systemctl restart docker

# Clear swarm environment if exists.
docker node rm $(sudo docker node ls | grep Down | awk -F" " '{ print $1 }')
docker swarm leave --force

docker swarm init --advertise-addr eth0

if [ $? -eq 0 ]; then
	echo WARNING! Swarm initialized successfully.
else
	echo ERROR! Swarm initialization failed. Check the network configuration and retry.
	exit 1
fi