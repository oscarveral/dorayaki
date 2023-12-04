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

# Clear existing rules and set the default policies
iptables -F
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# Allow traffic on the loopback interface
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# SNAT. Hide internal networks behind eth2.
iptables -t nat -A POSTROUTING -o eth2 -j MASQUERADE

# Allow outbound traffic from this machine to the internet.
iptables -A OUTPUT -o eth2 -j ACCEPT
# Allow outbound traffic to the internal network only if it is related to an established connection or related to a previous request.
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
# Allow related inbound traffic for all interfaces.
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
# Allow forward related and established connections.
iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT

# DHCP. Only allow DHCP traffic from the internal networks of eth0 and eth1.
iptables -A INPUT -i eth0 -p udp --dport 67:68 --sport 67:68 -j ACCEPT
iptables -A INPUT -i eth1 -p udp --dport 67:68 --sport 67:68 -j ACCEPT

# OpenVPN. Only allow OpenVPN stablish traffic from outside the organization.
iptables -A INPUT -i eth2 -p udp --dport 1194 -j ACCEPT

# SSH. Restric only SSH from external network.
iptables -A INPUT -i eth2 -p tcp --dport 22 -m state --state NEW -j REJECT --reject-with icmp-host-prohibited
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT
iptables -A FORWARD -i eth2 -p tcp --dport 22 -m state --state NEW -j REJECT --reject-with icmp-host-prohibited
iptables -A FORWARD -p tcp --dport 22 -m state --state NEW -j ACCEPT

# DNS. Allow DNS traffic only to DNS server and from DNS server to external networks. As this is a public service, DNAT is needed.
iptables -t nat -A PREROUTING -i eth2 -p udp --dport 53 -j DNAT --to-destination 172.16.2.254
iptables -A FORWARD -o eth1 -d 172.16.2.254 -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -i eth1 -s 172.16.2.254 -p udp --sport 53 -o eth2 -p udp -dport 53 -j ACCEPT

# Radius. It can be used only by servers LAN. Default rejection is applied.
# Docker Swarm. Is used only by servers LAN. Default rejection is applied.

# Reject all other incoming and forwarding traffic.
iptables -A INPUT -j REJECT --reject-with icmp-host-prohibited
iptables -A FORWARD -j REJECT --reject-with icmp-host-prohibited

iptables-save > /etc/iptables/rules.v4