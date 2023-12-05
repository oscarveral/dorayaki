#!/bin/bash

if [ "$SCRIPT_PATH" != "$CURRENT_PATH" ]; then
	echo ERROR! This script must be executed from the same directory it is located. 1>&2
	exit 1
fi

if [ "$EUID" -ne 0 ]
  then echo ERROR! Please run as root. 1>&2
  exit 1
fi

# Uncomment DNSStubListener=no in /etc/systemd/resolved.conf. To use the DNS server in the host.
sed -i 's/#DNSStubListener=yes/DNSStubListener=no/g' /etc/systemd/resolved.conf 2> /dev/null
# Force to use external interface as DNS server.
sed -i 's/#DNS=/DNS=172.16.2.254/g' /etc/systemd/resolved.conf 2> /dev/null