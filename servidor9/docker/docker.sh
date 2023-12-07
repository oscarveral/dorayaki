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

usermod -aG docker $(logname)

docker pull freeradius/freeradius-server:latest
docker pull greenbone/vulnerability-tests
docker pull greenbone/notus-data
docker pull greenbone/scap-data
docker pull greenbone/cert-bund-data
docker pull greenbone/dfn-cert-data
docker pull greenbone/data-objects
docker pull greenbone/report-formats
docker pull greenbone/gpg-data
docker pull greenbone/redis-server
docker pull greenbone/pg-gvm:stable
docker pull greenbone/gvmd:stable
docker pull greenbone/gsa:stable
docker pull greenbone/ospd-openvas:stable
docker pull greenbone/mqtt-broker
docker pull greenbone/notus-scanner:stable
docker pull greenbone/gvm-tools

docker rm -f $(docker ps -aq) 2> /dev/null

cp compose.yaml /etc/docker/compose.yaml

sudo -u $(logname) docker compose build 2> /dev/null
sudo -u $(logname) docker compose up -d 2> /dev/null

sudo -u $(logname) docker compose -f compose.yml -p greenbone-community-edition pull notus-data vulnerability-tests scap-data dfn-cert-data cert-bund-data report-formats data-objects
sudo -u $(logname) docker compose -f compose.yml -p greenbone-community-edition up -d notus-data vulnerability-tests scap-data dfn-cert-data cert-bund-data report-formats data-objects