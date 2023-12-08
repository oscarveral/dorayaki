#!/bin/bash

minikube start --memory=1900 --driver=docker

sudo nohup minikube tunnel &