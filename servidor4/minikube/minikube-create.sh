#!/bin/bash

minikube start --memory=1900 --driver=docker

minikube addons enable metrics-server

nohup minikube dashboard 2> /dev/null &

minikube kubectl -- apply -f /etc/kubernets-docker/config.yaml

minikube kubectl -- port-forward service/nginx-service 8080:30080

#CLUSTER_IP=$(minikube ip)
#sudo iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination $CLUSTER_IP:30080