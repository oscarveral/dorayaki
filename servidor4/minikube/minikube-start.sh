#!/bin/bash

minikube start --memory=1900 --driver=docker

nohup minikube tunnel &