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

apt-get install -y proftpd

adduser --home /home/ftp ftpuser
passwd ftpuser

rm /etc/proftpd/proftpd.conf
touch /etc/proftpd/proftpd.conf

echo "ServerName \"$(hostname)\"" >> /etc/proftpd/proftpd.conf
echo "Port 21" >> /etc/proftpd/proftpd.conf
echo "AuthOrder mod_auth_file.c" >> /etc/proftpd/proftpd.conf
echo "RequireValidShell on" >> /etc/proftpd/proftpd.conf

systemctl enable --now proftpd