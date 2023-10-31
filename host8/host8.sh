#!/bin/bash

echo WARNING! Execute this script on the same directory it is located.

# Configuración de nombres local de la máquina. Permite facilitar la identificación de la máquina en la red.
hostnamectl hostname "host8" --static
hostnamectl hostname "Host de auditoría." --pretty
hostnamectl icon-name host8
hostnamectl chassis vm
hostnamectl deployment vm
hostnamectl location vm

# Habilitar el servicio de SSH.
systemctl enable --now sshd