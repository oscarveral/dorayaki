#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo ERROR! Please run as root. 1>&2
  exit 1
fi

# Install docker script.

dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

docker start

usermod -aG docker $(logname)

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

sudo -u $(logname) docker compose up -d