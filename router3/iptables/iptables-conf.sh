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

apt-get install iptables iptables-persistent -y

iptables -F
iptables -F -t nat

# SNAT. Hide internal networks behind ISP interface.
iptables -t nat -A POSTROUTING  ! -o 192.168.1.0/24  -j MASQUERADE

# Drop TRACEROUTE
iptables -A OUTPUT -p icmp --icmp-type time-exceeded -j DROP

iptables-save > /etc/iptables/rules.v4
