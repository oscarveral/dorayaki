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

mkdir /etc/path
mkdir /etc/path/to
mkdir /etc/path/to/data
mkdir /etc/path/to/main/
mkdir /etc/path/to/main/config
curl https://scripttiger.github.io/hosts-packages/hosts -o blacklist.txt

#cp blacklist.txt /etc/path/to/
cp squid.conf /etc/path/to/main/config

rm blacklist.txt

docker compose up -d

