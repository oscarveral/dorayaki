#!/bin/bash

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
CURRENT_PATH="$(pwd)"

if [ "$SCRIPT_PATH" != "$CURRENT_PATH" ]; then
	echo ERROR! This script must be executed from the same directory it is located. 1>&2
	exit 1
fi

if [ "$EUID" -ne 0 ]
  then echo ERROR! Please run as root. 1>&2
  exit 1
fi

# Force disable MAC randomization.
rm /etc/NetworkManager/conf.d/* 2> /dev/null
cp network.conf /etc/NetworkManager/conf.d/10-network.conf

# Network configuration.
systemctl stop NetworkManager
rm /etc/NetworkManager/system-connections/* 2> /dev/null
systemctl start NetworkManager

# Interfaz de red solo anfitrión para uso de SSH desde el anfitrión de la VM.
nmcli con add type ethernet con-name eth0 ifname eth0 ipv4.method manual ip4 192.168.63.40/24 ipv4.ignore-auto-dns yes 2> /dev/null
# Interfaz para uso cotidiano por parte del usuario de la maquina.
nmcli con add type ethernet con-name eth1 ifname eth1 ipv4.method auto 2> /dev/null

systemctl restart NetworkManager