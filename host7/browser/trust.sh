#!/bin/bash

# Add the HTTPS server certfiicate to the trust store.
# Maybe you will need to disable the self signed certificate check in your browser.

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

curl -k https://www.dorayaki.org:8443/nginx.crt -o nginx.crt

dnf install -y openssl

openssl x509 -in nginx.crt -out nginx.pem -outform PEM

rm nginx.crt

mv nginx.pem /etc/pki/ca-trust/source/anchors/

update-ca-trust