#!/bin/bash

systemctl stop minikube.service

/etc/kubernets-docker/minikube-delete.sh

systemctl restart minikube.service