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

# Rename interfaces.
cp udev/10-persistent-net.rules /etc/udev/rules.d/10-persistent-net.rules

# Network configuration.
nmcli con add type ethernet con-name eth1 ifname eth1 ip4.method auto
nmcli con modify eth1 connection.interface-name eth1

echo WARNING! Configuration finished. Power off this machine and disable the original NAT network card.

# Remove this repo automatically from the system.
rm -r ../../dorayaki