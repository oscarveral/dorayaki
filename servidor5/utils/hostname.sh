#!/bin/bash

# Configuración de nombres local de la máquina. Permite facilitar la 
# identificación de la máquina en la red. Se recibirá un FQDN del servidor DHCP.

if [ "$EUID" -ne 0 ]
  then echo ERROR! Please run as root. 1>&2
  exit
fi

hostnamectl hostname "" --static
hostnamectl hostname "Servidor con id 5 de Dorayaki." --pretty
hostnamectl icon-name servidor5
hostnamectl chassis vm
hostnamectl deployment vm
hostnamectl location vm