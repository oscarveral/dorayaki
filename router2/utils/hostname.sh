#!/bin/bash

# Configuración de nombres local de la máquina. Permite facilitar la 
# identificación de la máquina en la red. Se recibirá un FQDN del servidor DHCP.

if [ "$EUID" -ne 0 ]
  then echo ERROR! Please run as root. 1>&2
  exit 1
fi

# Configuración de nombres local de la máquina. Permite facilitar la identificación de la máquina en la red.
hostnamectl hostname "router2" --static
hostnamectl hostname "Router del ISP" --pretty
hostnamectl icon-name router2
hostnamectl chassis vm
hostnamectl deployment vm
hostnamectl location vm