#!/bin/bash

echo WARNING! Execute this script on the same directory it is located.

# Configuración de nombres local de la máquina. Permite facilitar la identificación de la máquina en la red.
hostnamectl hostname "host6" --static
hostnamectl hostname "Host de la organización Dorayaki." --pretty
hostnamectl icon-name host6
hostnamectl chassis vm
hostnamectl deployment vm
hostnamectl location vm

# Habilitar el servicio de SSH.
systemctl enable --now sshd

# Rename interfaces. Aplicable on next boot.
cp udev/persistent.rules /etc/udev/rules.d/10-persistent-net.rules

# Force disable MAC randomization.
rm /etc/NetworkManager/conf.d/*
cp network_manager/network.conf /etc/NetworkManager/conf.d/10-network.conf

# Network configuration.
systemctl start NetworkManager
rm /etc/NetworkManager/system-connections/*
# Interfaz de red solo anfitrión para uso de SSH desde el anfitrión de la VM.
nmcli con add type ethernet con-name eth0 ifname eth0 ipv4.method manual ip4 192.168.62.40/24
# Interfaz para uso cotidiano por parte del usuario de la maquina.
nmcli con add type ethernet con-name eth1 ifname eth1 ipv4.method auto
systemctl restart NetworkManager

echo WARNING! Configuration finished. Power-off this machine and finish the configuration.

# Remove this repo automatically from the system.
rm -r ../../dorayaki
cd