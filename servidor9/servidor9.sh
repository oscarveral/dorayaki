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

cd utils
./hostname.sh > /dev/null
./packages.sh > /dev/null
cd ..

cd ssh
./ssh.sh > /dev/null
cd ..

cd radius
./radius.sh > /dev/null
cd ..

cd docker
./docker.sh > /dev/null
cd ..

cd greenbone
./greenbone.sh > /dev/null
cd ..

cd nagios
./nagios.sh > /dev/null
cd ..

cd netplan
./network.sh > /dev/null
cd ..

echo Script configuration finished successfully. 1>&2