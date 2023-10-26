#!/bin/bash

echo WARNING! Execute this script on the same directory it is located. If asked any input, press ENTER.

# Configuración de nombres local de la máquina. Permite facilitar la identificación de la máquina en la red.
hostnamectl hostname "router-dorayaki" --static
hostnamectl hostname "Router de la sede Dorayaki" --pretty
hostnamectl icon-name router-dorayaki
hostnamectl chassis vm
hostnamectl deployment vm
hostnamectl location vm


# Configuración de las interfaces de red. Permite que la máquina pueda comunicarse con otras máquinas.
rm /etc/netplan/00-installer-config.yaml
# Restrict permissions to avoid warnings
chmod 600 netplan/network.yaml
cp netplan/network.yaml /etc/netplan/
netplan apply

echo WARNING! Configuration finished. Power off this machine and disable the original NAT network card.



# Remove this repo automatically from the system.
rm -r ../../dorayaki