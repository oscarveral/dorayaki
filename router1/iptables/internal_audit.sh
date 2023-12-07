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

# Internal audit enable firewall configuration script.

# Forward any traffic from this server to allow monitoring of other servers.
# THIS IS NOT RECOMMENDED. IT IS ONLY USED FOR EDUCATIONAL PURPOSES.
iptables -A FORWARD -i eth0 -s 172.16.1.2 -j ACCEPT
iptables -A INPUT -i eth0 -s 172.16.1.2 -j ACCEPT

iptables-save > /etc/iptables/rules.v4