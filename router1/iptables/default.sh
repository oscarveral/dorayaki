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

HOSTS="eth0"
SERVERS="eth1"
ISP="eth2"
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

# SNAT. Hide internal networks behind eth2.
iptables -t nat -A POSTROUTING -o eth2 -j MASQUERADE

# Allow related inbound traffic for all interfaces.
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Allow internal networks to access external networks and allow responses back in.
iptables -A FORWARD -o eth2 -j ACCEPT
iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT

# DHCP. Only allow DHCP traffic from the internal networks of eth0 and eth1.
iptables -A INPUT -i eth0 -p udp --dport 67:68 --sport 67:68 -j ACCEPT
iptables -A INPUT -i eth1 -p udp --dport 67:68 --sport 67:68 -j ACCEPT

# OpenVPN. Only allow OpenVPN stablish traffic from outside the organization.
iptables -A INPUT -i eth2 -p udp --dport 1194 -j ACCEPT

# SSH. Restric only SSH from external network.
iptables -A INPUT -i eth2 -p tcp --dport 22 -m state --state NEW -j REJECT --reject-with icmp-host-prohibited
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A FORWARD -i eth2 -p tcp --dport 22 -m state --state NEW -j REJECT --reject-with icmp-host-prohibited
iptables -A FORWARD -p tcp --dport 22 -j ACCEPT

# DNS. Allow DNS traffic only to DNS server and from DNS server to external networks. As this is a public service, DNAT is needed.
iptables -t nat -A PREROUTING -i eth2 -p udp --dport 53 -j DNAT --to-destination 172.16.2.254
iptables -A FORWARD -o eth1 -d 172.16.2.254 -p udp --dport 53 -j ACCEPT

# Radius. Allow requests only from servers LAN to internal server.
iptables -A FORWARD -i eth1 -s 172.16.2.0/24 -p udp --dport 1812 -d 172.16.1.2 -j ACCEPT

# Greenbone. Allow access to web interface only to organization hosts. As only VPN clients are outside the organization, we need to allow access.
# Physical hosts on office already have access to this service as they share LAN with the server.
iptables -A FORWARD -i tun0 -o eth0 -s 172.16.1.0/24 -p tcp --dport 9392 -d 172.16.1.2 -j ACCEPT

# Wordpress. Allow access to any host on the internet. As this is a public service, DNAT is needed.
iptables -t nat -A PREROUTING -i eth2 -p tcp --dport 80 -j DNAT --to-destination 172.16.2.2
iptables -A FORWARD -o eth1 -d 172.16.2.2 -p tcp --dport 80 -j ACCEPT

# Wordpress admin panel. Allow access to host on office only.
iptables -A FORWARD -i eth0 -o eth1 -s 172.16.1.0/24 -p tcp --dport 9000 -d 172.16.2.2 -j ACCEPT

# HTTPS Server. Allow requests HTTPS request only to this server. As this is a public service, DNAT is needed.
iptables -t nat -A PREROUTING -p tcp --dport 8443 -j DNAT --to-destination 172.16.2.2
iptables -A FORWARD -o eth1 -d 172.16.2.2 -p tcp --dport 8443 -j ACCEPT

# Docker Swarm. Is used only by servers LAN. Default rejection is applied.

iptables-save > /etc/iptables/rules.v4
