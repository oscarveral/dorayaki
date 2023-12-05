#!/bin/bash

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
CURRENT_PATH="$(pwd)"

if [ "$SCRIPT_PATH" != "$CURRENT_PATH" ]; then
	echo ERROR! This script must be executed from the same directory it is located. 1>&2
	exit 1
fi

if [ "$EUID" -ne 0 ]
  then echo ERROR! Please run as root. 1>&2
  exit 1
fi

mkdir /etc/kubernets-docker/ 2> /dev/null

# Check if installed.log is present at /etc/kubernets-docker/
if [ ! -f /etc/kubernets-docker/installed.log ]; then
	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	install minikube-linux-amd64 /usr/local/bin/minikube
	touch /etc/kubernets-docker/installed.log
fi

cp minikube-start.sh /etc/kubernets-docker/
cp minikube-stop.sh /etc/kubernets-docker/

# Add docker user to main user group.
usermod -aG docker servidor4

# Execute minikube-start.sh and minikube-stop.sh as servidor4 user.
sudo -u servidor4 /etc/kubernets-docker/minikube-stop.sh
sudo -u servidor4 /etc/kubernets-docker/minikube-start.sh