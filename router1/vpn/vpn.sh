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

apt-get install -y openvpn openvpn-auth-radius freeradius-utils easy-rsa

mkdir /etc/openvpn/easy-rsa 2> /dev/null
cp vars /etc/openvpn/easy-rsa/

cd /etc/openvpn

ln -s /usr/share/easy-rsa/* easy-rsa/ 2> /dev/null

cd easy-rsa
./easyrsa --batch clean-all 2> /dev/null
./easyrsa --batch init-pki 2> /dev/null
./easyrsa --batch build-ca nopass 2> /dev/null
./easyrsa --batch build-server-full dorayaki-vpn nopass 2> /dev/null
./easyrsa --batch build-client-full dorayaki-client nopass 2> /dev/null
./easyrsa --batch gen-dh 2> /dev/null

cp pki/ca.crt /home/admin/vpn.crt
cp pki/issued/dorayaki-client.crt /home/admin/dorayaki-client.crt
cp pki/private/dorayaki-client.key /home/admin/dorayaki-client.key
chmod 644 /home/admin/vpn.crt

cd ..

mkdir keys 2> /dev/null
cp easy-rsa/pki/ca.crt keys/
cp easy-rsa/pki/issued/dorayaki-vpn.crt keys/
cp easy-rsa/pki/private/dorayaki-vpn.key keys/
cp easy-rsa/pki/dh.pem keys/

cd $CURRENT_PATH

cp server.conf /etc/openvpn/
cp radius.cnf /etc/openvpn/

deluser --remove-home openvpn 2> /dev/null
adduser --system --shell /usr/sbin/nologin --no-create-home --group openvpn

systemctl enable openvpn@server --now