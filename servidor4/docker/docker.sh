#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo ERROR! Please run as root. 1>&2
  exit
fi

# Install docker script.

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; 
  do apt remove $pkg; 
done

apt update 2> /dev/null
apt install ca-certificates curl gnupg -y 2> /dev/null

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update 2> /dev/null
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y 2> /dev/null