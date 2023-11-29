#!/bin/bash

echo WARNING! Execute this script on the same directory it is located.

# Hostname.
./utils/hostname.sh > /dev/null

# Packages.
./utils/packages.sh > /dev/null

# Docker.
./docker/docker.sh > /dev/null

# Network.
./netplan/network.sh > /dev/null

# Swarm.
./swarm/swarm.sh > /dev/null

echo WARNING! Configuration finished. Power off this machine and disable the original NAT network card.