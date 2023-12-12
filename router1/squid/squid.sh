#!/bin/bash

mkdir path
mkdir path/to
mkdir path/to/squid

curl https://scripttiger.github.io/hosts-packages/hosts -o blacklist.txt

cp blacklist.txt path/to/
cp squid.conf path/to/

docker compose up -d

