#!/bin/bash

# Instalar ping y otras utilidades para depurar.

if [ "$EUID" -ne 0 ]
  then echo ERROR! Please run as root. 1>&2
  exit 1
fi

apt-get install inetutils-ping vim tcpdump dnsutils -y