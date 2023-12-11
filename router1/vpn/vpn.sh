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

cp server.conf /etc/openvpn/
cp radius.cnf /etc/openvpn/

# Si no hay certificados generados se vuelve.
if [ ! -f /home/router1/vpnCA/CA_cert.pem ] || [ ! -f /home/router1/vpnCA/certs/vpn_cert.pem ] || [ ! -f /home/router1/vpnCA/Pkeys/vpn_pkey.pem ] || [ ! -f /home/router1/vpnCA/dh2048.pem ]; then
	echo ERROR! Certificates not found. 1>&2
	exit 1
fi

cp /home/router1/vpnCA/CA_cert.pem /etc/openvpn/ca.pem
cp /home/router1/vpnCA/certs/vpn_cert.pem /etc/openvpn/vpn.pem
cp /home/router1/vpnCA/Pkeys/vpn_pkey.pem /etc/openvpn/vpn.key
cp /home/router1/vpnCA/dh2048.pem /etc/openvpn/dh.pem

cp /home/router1/vpnCA/CA_cert.pem /home/admin/
cp /home/router1/vpnCA/certs/client_cert.pem /home/admin/
cp /home/router1/vpnCA/Pkeys/client_pkey.pem /home/admin/

deluser --remove-home openvpn 2> /dev/null
adduser --system --shell /usr/sbin/nologin --no-create-home --group openvpn

systemctl enable openvpn@server --now