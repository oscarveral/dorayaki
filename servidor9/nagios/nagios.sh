#!/bin/bash

if [ "$SCRIPT_PATH" != "$CURRENT_PATH" ]; then
	echo ERROR! This script must be executed from the same directory it is located. 1>&2
	exit 1
fi

if [ "$EUID" -ne 0 ]
  then echo ERROR! Please run as root. 1>&2
  exit 1
fi

mkdir -p /data/nagios/conf
mkdir -p /data/nagios/plugin
mkdir -p /data/nagios/example

cp services.cfg /data/nagios/conf/

docker pull ethnchao/nagios
docker pull mysql:5.6

docker compose up -d &


