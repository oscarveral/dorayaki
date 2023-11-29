#!/bin/bash

# Instalar ping y otras utilidades para depurar.

if [ "$EUID" -ne 0 ]
  then echo ERROR! Please run as root. 1>&2
  exit
fi

apt-cache install inetutils-ping vim tcpdump -y