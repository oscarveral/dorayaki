#!/bin/bash

echo WARNING! Execute this script on the same directory it is located.

# Configuración de nombres local de la máquina. Permite facilitar la identificación de la máquina en la red.
hostnamectl hostname "" --static # Se recibirá un FQDN del servidor DHCP.
hostnamectl hostname "Servidor con id 5 de Dorayaki." --pretty
hostnamectl icon-name servidor5
hostnamectl chassis vm
hostnamectl deployment vm
hostnamectl location vm

# Instalar ping y otras utilidades para depurar.
echo If asked for input, press ENTER.
apt install inetutils-ping vim tcpdump -y

# Configuración de las interfaces de red. Permite que la máquina pueda comunicarse con otras máquinas.
rm /etc/netplan/00-installer-config.yaml
# Restrict permissions to avoid warnings
chmod 600 netplan/network.yaml
cp netplan/network.yaml /etc/netplan/
netplan apply

echo WARNING! Configuration finished. Power off this machine and disable the original NAT network card.

# Remove this repo automatically from the system.
rm -r ../../dorayaki