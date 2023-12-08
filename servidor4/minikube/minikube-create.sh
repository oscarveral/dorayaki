#!/bin/bash

minikube start --memory=1900 --driver=docker

minikube addons enable metrics-server

nohup minikube dashboard 2> /dev/null &

minikube kubectl -- apply -f /etc/kubernets-docker/config.yaml