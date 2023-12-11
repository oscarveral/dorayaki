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

curl https://www.dorayaki.org:8443/vpn.crt -o /etc/openvpn/client/vpn.crt
curl https://www.dorayaki.org:8443/dorayaki-client.crt -o /etc/openvpn/client/dorayaki-client.crt
curl https://www.dorayaki.org:8443/dorayaki-client.key -o /etc/openvpn/client/dorayaki-client.key

cp client.conf /etc/openvpn/client/

systemctl enable openvpn@client --now