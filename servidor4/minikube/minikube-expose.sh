#!/bin/bash

# Get external ip for nginx-service
EXTERNAL_IP=$(minikube kubectl -- get svc nginx-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Add iptables rule to forward port 8080 to 8080 on external ip
iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination $EXTERNAL_IP:8080