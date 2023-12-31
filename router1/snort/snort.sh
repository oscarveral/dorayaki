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

mkdir -p /etc/snort/rules/ 2> /dev/null

cp local.rules /etc/snort/rules/
cp white_list.rules /etc/snort/rules/
cp black_list.rules /etc/snort/rules/

docker compose up -d

docker exec -it snort snort -i eth0 -c /etc/snort/etc/snort.conf -A console