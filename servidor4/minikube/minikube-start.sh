#!/bin/bash

rm nohup.out 2> /dev/null

minikube start --memory=1900 --driver=docker

#minikube addons enable ingress
minikube addons enable metrics-server

nohup minikube dashboard &

minikube kubectl -- apply -f ~/minikube/config.yaml

stop=""
while [ "$stop" == "" ] 
do
  echo "Waiting..."
  sleep 1
  stop=$(minikube kubectl -- get po -A | grep -e "foo.*Running")
  echo "$stop"
done

nohup minikube kubectl -- port-forward service/foo-service 8080:8080 &

minikube kubectl -- get po -A
