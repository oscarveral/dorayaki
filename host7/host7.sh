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
./services.sh > /dev/null
cd ..

cd udev
./udev.sh > /dev/null
cd ..

cd browser
./trust.sh > /dev/null
cd ..

cd network_manager
./network.sh > /dev/null
cd ..

echo Script configuration finished successfully. 1>&2