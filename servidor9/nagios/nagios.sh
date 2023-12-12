#!/bin/bash

if [ "$SCRIPT_PATH" != "$CURRENT_PATH" ]; then
	echo ERROR! This script must be executed from the same directory it is located. 1>&2
	exit 1
fi

if [ "$EUID" -ne 0 ]
  then echo ERROR! Please run as root. 1>&2
  exit 1
fi

mkdir -p /data/nagios/etc
mkdir -p /data/nagios/var
mkdir -p /data/nagios/db_data

mkdir -p /data/nagios/conf
mkdir -p /data/nagios/plugin
mkdir -p /data/nagios/example

docker compose up -d &


