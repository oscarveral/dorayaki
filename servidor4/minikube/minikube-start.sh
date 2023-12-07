#!/bin/bash

minikube start --memory=1900 --driver=docker

minikube addons enable metrics-server

nohup minikube tunnel &

#nohup minikube dashboard 2> /dev/null &

minikube kubectl -- apply -f config.yaml

stop=""
while [ "$stop" == "" ] 
do
  echo "Waiting..."
  sleep 1
  stop=$(minikube kubectl -- get pods -A | grep -e "nginx.*Running")
  echo "$stop"
done

#nohup minikube kubectl -- port-forward service/nginx-service 8080:8080 & 

minikube kubectl -- get pods -A