#!/bin/bash

cd /etc/kubernets-docker/

rm nohup.out 2> /dev/null

minikube start --memory=1900 --driver=docker

#minikube addons enable ingress
minikube addons enable metrics-server 2> /dev/null

nohup minikube dashboard 2> /dev/null &

minikube kubectl -- apply -f /etc/kubernets-docker/config.yaml 2> /dev/null

stop=""
while [ "$stop" == "" ] 
do
  echo "Waiting..."
  sleep 1
  stop=$(minikube kubectl -- get po -A | grep -e "foo.*Running")
  echo "$stop"
done

nohup minikube kubectl -- port-forward service/foo-service 8080:8080 2> /dev/null & 

minikube kubectl -- get po -A 2> /dev/null

rm nohup.out 2> /dev/null