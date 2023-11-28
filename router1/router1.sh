#!/bin/bash

echo WARNING! Execute this script on the same directory it is located.

# Configuración de nombres local de la máquina. Permite facilitar la identificación de la máquina en la red.
hostnamectl hostname "router1" --static
hostnamectl hostname "Router de la sede Dorayaki" --pretty
hostnamectl icon-name router1
hostnamectl chassis vm
hostnamectl deployment vm
hostnamectl location vm

# Instalar ping y otras utilidades para depurar.
echo If asked for input, press ENTER.
apt install inetutils-ping vim tcpdump -y

# Configurar NAT/firewall con iptables
chmod 700 iptables/iptables-conf.sh
echo If asked for input, write yes to save current config.
apt install iptables iptables-persistent -y
./iptables/iptables-conf.sh

# DHCP Server configuration.
apt install kea -y
# Not setting a password on kea-ctrl-agent so it is not enabled
cp kea/kea-dhcp4.conf /etc/kea/kea-dhcp4.conf
systemctl restart kea-dhcp4-server

# Configuración de las interfaces de red. Permite que la máquina pueda comunicarse con otras máquinas.
rm /etc/netplan/00-installer-config.yaml
# Restrict permissions to avoid warnings
chmod 600 netplan/network.yaml
cp netplan/network.yaml /etc/netplan/
netplan apply

# Configurar parámetros del kernel mediante sysctl.
rm /etc/sysctl.conf
# Restrict permissions to avoid warnings
chmod 600 sysctl/sysctl.conf
cp sysctl/sysctl.conf /etc/
sysctl -p

echo WARNING! Configuration finished. Power off this machine and disable the original NAT network card.

# Remove this repo automatically from the system.
rm -r ../../dorayaki