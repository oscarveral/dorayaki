#!/bin/bash

# Configuración de DNS Bind9. Se ejecutará en un contenedor Docker.

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

rm -r /etc/bind 2> /dev/null
mkdir -p /etc/bind 2> /dev/null

cp named.conf /etc/bind/named.conf
cp named.conf.options /etc/bind/named.conf.options
cp named.conf.local /etc/bind/named.conf.local

rm -r /etc/bind/zones 2> /dev/null
mkdir -p /etc/bind/zones

cp db.dorayaki.org /etc/bind/zones/db.dorayaki.org
cp db.172.16.2 /etc/bind/zones/db.172.16.2