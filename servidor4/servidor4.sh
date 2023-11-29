#!/bin/bash

echo WARNING! Execute this script on the same directory it is located.

# Configuración de nombres local de la máquina. Permite facilitar la identificación de la máquina en la red.
hostnamectl hostname "" --static # Se recibirá un FQDN del servidor DHCP.
hostnamectl hostname "Servidor con id 4 de Dorayaki." --pretty
hostnamectl icon-name servidor4
hostnamectl chassis vm
hostnamectl deployment vm
hostnamectl location vm

# Instalar ping y otras utilidades para depurar.
echo If asked for input, press ENTER.
apt install inetutils-ping vim tcpdump -y

# Instalar docker.
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do apt remove $pkg; done
apt update
apt install ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y


# Configuración de las interfaces de red. Permite que la máquina pueda comunicarse con otras máquinas.
rm /etc/netplan/00-installer-config.yaml
# Restrict permissions to avoid warnings
chmod 600 netplan/network.yaml
cp netplan/network.yaml /etc/netplan/
netplan apply

echo WARNING! Configuration finished. Power off this machine and disable the original NAT network card.

# Remove this repo automatically from the system.
rm -r ../../dorayaki