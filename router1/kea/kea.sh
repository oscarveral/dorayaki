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

# DHCP Server configuration.

apt-get install kea -y
# Not setting a password on kea-ctrl-agent so it is not enabled
cp kea-dhcp4.conf /etc/kea/kea-dhcp4.conf
systemctl restart kea-dhcp4-server