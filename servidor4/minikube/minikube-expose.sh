#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo ERROR! Please run as root. 1>&2
  exit 1
fi

# Get external ip for nginx-service
EXTERNAL_IP=$(minikube kubectl -- get svc nginx-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Add iptables rule to forward port 8080 to 8080 on external ip
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 8080 -j DNAT --to-destination $EXTERNAL_IP