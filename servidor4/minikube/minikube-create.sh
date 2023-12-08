#!/bin/bash

minikube start --memory=1900 --driver=docker

minikube addons enable metrics-server

nohup minikube dashboard 2> /dev/null &

minikube kubectl -- apply -f /etc/kubernets-docker/config.yaml

nohup minikube kubectl -- port-forward --address 0.0.0.0 service/nginx-service 8080:80 2> /dev/null &