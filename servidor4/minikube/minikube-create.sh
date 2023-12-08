#!/bin/bash

minikube start --memory=1900 --driver=docker

minikube addons enable metrics-server

minikube image load nginx-custom

#nohup minikube dashboard &

minikube kubectl -- apply -f /etc/kubernets-docker/config.yaml

sleep 10
while [ "$(minikube kubectl -- get pods | grep -c "Running")" != "3" ]; do
	sleep 1
done

nohup minikube kubectl -- port-forward --address 0.0.0.0 service/nginx-service 443:443