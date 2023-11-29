#!/bin/bash

# Configuración de las interfaces de red. Permite que la máquina pueda 
# comunicarse con otras máquinas.

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
CURRENT_PATH="$(pwd)"

if [ "$SCRIPT_PATH" != "$CURRENT_PATH" ]; then
	echo ERROR! This script must be executed from the same directory it is located. 1>&2
	exit 1
fi

rm /etc/netplan/* 2> /dev/null
chmod 600 network.yaml
cp network.yaml /etc/netplan/
netplan apply 2> /dev/null