#!/bin/bash

echo WARNING! Execute this script on the same directory it is located.

# Configuración de nombres local de la máquina. Permite facilitar la identificación de la máquina en la red.
hostnamectl hostname "host8" --static
hostnamectl hostname "Host de auditoría." --pretty
hostnamectl icon-name host8
hostnamectl chassis vm
hostnamectl deployment vm
hostnamectl location vm

# Habilitar el servicio de SSH.
systemctl enable --now sshd

# Rename interfaces. Aplicable on next boot.
cp udev/persistent.rules /etc/udev/rules.d/10-persistent-net.rules

# Force disable MAC randomization.
cp network_manager/network.conf /etc/NetworkManager/conf.d/10-mac.conf

# Network configuration.
systemctl start NetworkManager
# Interfaz de red solo anfitrión para uso de SSH desde el anfitrión de la VM.
nmcli con add type ethernet con-name eth0 ifname eth0 ipv4.method manual ip4 192.168.64.40/24
# Interfaz para uso cotidiano por parte del usuario de la maquina.
nmcli con add type ethernet con-name eth1 ifname eth1 ipv4.method auto

# Método alternativo
# cp network_manager/eth0.nmconnection /etc/NetworkManager/system-connections/eth0.nmconnection
# cp network_manager/eth1.nmconnection /etc/NetworkManager/system-connections/eth1.nmconnection

systemctl restart NetworkManager

echo WARNING! Configuration finished. Power-off this machine and finish the configuration.

# Remove this repo automatically from the system.
rm -r ../../dorayaki