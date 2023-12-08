#!/bin/bash

minikube start --memory=1900 --driver=docker

minikube addons enable metrics-server

nohup minikube dashboard &

minikube kubectl -- apply -f /etc/kubernets-docker/config.yaml

minikube kubectl -- wait --for=condition=Ready pods --all

nohup minikube kubectl -- port-forward --address 0.0.0.0 service/nginx-service 8080:8080 &