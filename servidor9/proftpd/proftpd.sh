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

# Set defaut root to /home/proftpd
sed -i 's/DefaultRoot.*$/DefaultRoot ~/' /etc/proftpd/proftpd.conf

systemctl enable --now proftpd