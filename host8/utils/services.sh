#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo ERROR! Please run as root. 1>&2
  exit 1
fi

# Habilitar el servicio de SSH.
systemctl enable --now sshd

# Instalar paquetes necesarios.
dnf install -y nmap