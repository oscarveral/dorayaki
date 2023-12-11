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

curl https://www.dorayaki.org:8443/CA_cert.pem -o /etc/openvpn/client/CA_cert.pem
curl https://www.dorayaki.org:8443/client_cert.pem -o /etc/openvpn/client/client_cert.pem
curl https://www.dorayaki.org:8443/client_pkey.pem -o /etc/openvpn/client/client_pkey.pem

cp client.conf /etc/openvpn/client/
cp login.conf /etc/openvpn/client/

dnf install make -y

git clone https://github.com/jonathanio/update-systemd-resolved.git
cd update-systemd-resolved
make
cd ..
rm -rf update-systemd-resolved

systemctl enable openvpn-client@client --now