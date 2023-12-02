#!/bin/bash

# Configuración de nombres local de la máquina. Permite facilitar la 
# identificación de la máquina en la red. Se recibirá un FQDN del servidor DHCP.

if [ "$EUID" -ne 0 ]
  then echo ERROR! Please run as root. 1>&2
  exit 1
fi

hostnamectl hostname "infra0.dorayaki.org" --static 
hostnamectl hostname "Servidor de servicios maestros de Dorayaki." --pretty
hostnamectl icon-name master0
hostnamectl chassis vm
hostnamectl deployment vm
hostnamectl location vm