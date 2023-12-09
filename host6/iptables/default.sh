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

HOSTS_NET="172.16.1.0/24"
SERVERS_NET="172.16.2.0/24"

# Default firewall configuration script.

# Clear existing rules and set the default policies
iptables -F
iptables -F -t nat
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Allow traffic on the loopback interface
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow related inbound traffic for all interfaces.
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Allow SNMP from subnet
iptables -A INPUT -s "$HOSTS_NET" -p udp -m multiport --sports 161,162 -j ACCEPT


iptables-save > /etc/iptables/rules.v4
