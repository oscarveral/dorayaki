#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo ERROR! Please run as root. 1>&2
  exit 1
fi

# Install docker script.

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; 
  do apt-get remove $pkg; 
done

apt-get update
apt-get install ca-certificates curl gnupg -y

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

docker pull ubuntu/bind9:latest
docker pull freeradius/freeradius-server:latest

docker rm -f $(docker ps -aq) 2> /dev/null

cp compose.yaml /etc/docker/compose.yaml

docker compose build 2> /dev/null
docker compose up -d 2> /dev/null