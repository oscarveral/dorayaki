#!/bin/bash

#iptables -t nat -A POSTROUTING -o enp0s8 -j SNAT --to 1.2.3.2
#iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 22 -j DNAT --to 172.16.2.2

# Solo se necesita SNAT para dar acceso a internet a las máquinas del escenario.
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

# --- FIREWALL ---

#iptables -A INPUT -i enp0s8 -s 0.0.0.0/0 -d 172.16.0.0/12 -j DROP
#iptables -A INPUT -i lo -j ACCEPT
#iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
#iptables -A INPUT -j DROP

# --- LOADBALANCER ---
#iptables -A PREROUTING -t nat -p tcp -d 1.2.3.2 --dport 80 \
#         -m statistic --mode nth --every 2 --packet 0      \
#         -j DNAT --to-destination 172.16.2.2:80

#iptables -A PREROUTING -t nat -p tcp -d 1.2.3.2 --dport 80 \
#         -j DNAT --to-destination 172.16.1.254:80


iptables-save > /etc/iptables/rules.v4