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

cd /etc/openvpn

mkdir easy-rsa 2> /dev/null
ln -s /usr/share/easy-rsa/* easy-rsa/ 2> /dev/null

cd easy-rsa
./easyrsa --batch clean-all
./easyrsa --batch init-pki
./easyrsa --batch build-ca --req-cn=dorayaki-vpn nopass
./easyrsa --batch build-server-full dorayaki-vpn nopass
./easyrsa --batch gen-dh
cd ..

mkdir keys 2> /dev/null
cp easy-rsa/pki/ca.crt keys/
cp easy-rsa/pki/issued/dorayaki-vpn.crt keys/
cp easy-rsa/pki/private/dorayaki-vpn.key keys/
cp easy-rsa/pki/dh.pem keys/

cd $CURRENT_PATH

cp server.conf /etc/openvpn/

deluser --remove-home openvpn 2> /dev/null
adduser --system --shell /usr/sbin/nologin --no-create-home openvpn

systemctl enable openvpn@server --now