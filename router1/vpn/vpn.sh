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

apt-get install -y openvpn openvpn-auth-radius freeradius-utils

openvpn --genkey secret secret.key

cp server.conf /etc/openvpn/
cp radius.cnf /etc/openvpn/

cp secret.key /etc/openvpn/
cp server.key /home/admin/

rm secret.key

deluser --remove-home openvpn 2> /dev/null
adduser --system --shell /usr/sbin/nologin --no-create-home --group openvpn

systemctl enable openvpn@server --now