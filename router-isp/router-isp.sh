#!/bin/bash

echo WARNING! Execute this script on the same directory it is located.

# Configuración de nombres local de la máquina. Permite facilitar la identificación de la máquina en la red.
hostnamectl hostname "router-isp" --static
hostnamectl hostname "Router del ISP" --pretty
hostnamectl icon-name router-isp
hostnamectl chassis vm
hostnamectl deployment vm
hostnamectl location vm


# Configuración de las interfaces de red. Permite que la máquina pueda comunicarse con otras máquinas.
rm /etc/netplan/00-installer-config.yaml
# Restrict permissions to avoid warnings
chmod 600 netplan/network.yaml
cp netplan/network.yaml /etc/netplan/
netplan apply

echo WARNING! Configuration finished.

# Remove this repo automatically from the system.
rm -r ../../dorayaki