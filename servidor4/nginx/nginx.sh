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

mkdir /etc/nginx/ 2> /dev/null
cp Dockerfile /etc/nginx/

mkdir /etc/nginx/conf.d/ 2> /dev/null
cp https.conf /etc/nginx/conf.d/

mkdir /usr/share/nginx/ 2> /dev/null

if [ ! -f /etc/nginx/nginx.key ] || [ ! -f /etc/nginx/nginx.crt ]; then
	sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx.key -out nginx.crt -subj "/C=ES/ST=Murcia/L=Murcia/O=Dorayaki/CN=www.dorayaki.org"

	cp nginx.key /etc/nginx/
	cp nginx.crt /etc/nginx/

	mkdir -p /usr/share/nginx/cert 2> /dev/null
	cp nginx.crt /usr/share/nginx/cert/

	rm nginx.key
	rm nginx.crt
fi

mkdir -p /usr/share/nginx/https/ 2> /dev/null
cp index.html /usr/share/nginx/https/

docker build -t nginx-custom .