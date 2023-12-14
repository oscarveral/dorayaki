#!/bin/bash

minikube start --memory=1900 --driver=docker

minikube addons enable metrics-server
minikube addons enable dashboard

minikube image load nginx-custom

minikube kubectl -- apply -f /etc/kubernets-docker/config.yaml

sleep 10
while [ "$(minikube kubectl -- get pods | grep -c "Running")" != "3" ]; do
	sleep 1
done

# Get container name of kubernetes-dashboard
DASHBOARD_CONTAINER=$(minikube kubectl -- get pods | grep "kubernetes-dashboard" | awk '{print $1}')

nohup minikube kubectl -- proxy --address 0.0.0.0 $DASHBOARD_CONTAINER 10000:80 --namespace=kubernetes-dashboard --disable-filter=true &

nohup minikube kubectl -- port-forward --address 0.0.0.0 service/nginx-service 8443:443