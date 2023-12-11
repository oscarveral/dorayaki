#!/bin/bash

# User must be router1

rm -rf /home/router1/vpnCA 2> /dev/null

cp openssl.cnf /home/router1/
mkdir /home/router1/vpnCA

cd /home/router1/vpnCA

mkdir certs
mkdir crls
touch index.txt

mkdir CAkey
chmod 700 CAkey
mkdir Pkeys
chmod 700 Pkeys

mkdir reqs

echo "01" > serial

cd /home/router1

# CA
openssl req -new -sha512 -x509 -nodes -keyout vpnCA/CAkey/CA_key.pem -out vpnCA/CA_cert.pem -days 3650 -config ./openssl.cnf -subj "/C=ES/ST=Murcia/L=Murcia/O=Dorayaki/CN=dorayaki.org/OU=VPN/emailAddress=admin@dorayaki.org"

# Server
openssl req -new -sha512 -nodes -keyout vpnCA/Pkeys/vpn_pkey.pem -out vpnCA/reqs/vpn_req.pem -config ./openssl.cnf -subj "/C=ES/ST=Murcia/L=Murcia/O=Dorayaki/CN=dorayaki.org/OU=VPN/emailAddress=admin@dorayaki.org"
openssl ca -in vpnCA/reqs/vpn_req.pem -batch -out vpnCA/certs/vpn_cert.pem -config ./openssl.cnf

# Client
openssl req -new -sha512 -nodes -keyout vpnCA/Pkeys/client_pkey.pem -out vpnCA/reqs/client_req.pem -config ./openssl.cnf -subj "/C=ES/ST=Murcia/L=Murcia/O=Dorayaki/CN=vpnclient.dorayaki.org/OU=VPN/emailAddress=admin@dorayaki.org"
openssl ca -in vpnCA/reqs/client_req.pem -batch -out vpnCA/certs/client_cert.pem -config ./openssl.cnf

# Diffie-Hellman
openssl dhparam -out vpnCA/dh2048.pem 2048

echo "01" > serial