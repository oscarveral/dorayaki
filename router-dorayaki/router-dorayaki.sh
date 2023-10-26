#!/bin/bash

echo WARNING! Execute this script on the same directory it is located.

# Configuración de nombres local de la máquina. Permite facilitar la identificación de la máquina en la red.
hostnamectl hostname "router-dorayaki" --static
hostnamectl hostname "Router de la sede Dorayaki" --pretty
hostnamectl icon-name router-dorayaki
hostnamectl chassis vm
hostnamectl deployment vm
hostnamectl location vm


# Configuración de las interfaces de red. Permite que la máquina pueda comunicarse con otras máquinas.
rm /etc/netplan/00-installer-config.yaml
cp netplan/network.yaml /etc/netplan/
netplan apply

# TODO: Configurar Servidores DNS para que pueda obtener el nombre de dominio al que pertenece la máquina.

echo WARNING! Configuration finished. Power off this machine and disable the original NAT network card.