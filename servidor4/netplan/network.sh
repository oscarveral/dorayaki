#!/bin/bash

# Configuración de las interfaces de red. Permite que la máquina pueda 
# comunicarse con otras máquinas.

rm /etc/netplan/00-installer-config.yaml
chmod 600 netplan/network.yaml
cp netplan/network.yaml /etc/netplan/
netplan apply 2> /dev/null