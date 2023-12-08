#!/bin/bash

sudo -u $(logname) minikube start --memory=1900 --driver=docker

sudo -u $(logname) minikube addons enable metrics-server

#nohup minikube dashboard 2> /dev/null &

sudo -u $(logname) minikube kubectl -- apply -f config.yaml

nohup minikube tunnel &

#nohup minikube kubectl -- port-forward service/nginx-service 8080:8080 & 