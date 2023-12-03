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

# Add admin user with disabled password
userdel admin 2> /dev/null
rm -r /home/admin 2> /dev/null
useradd -m --disabled-password --gecos "" admin

# Modify sshd_config
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/UsePAM no/UsePAM yes/g' /etc/ssh/sshd_config

# Modify pam.d/sshd
sed -i 's/@include common-auth/auth sufficient pam_radius_auth.so/g' /etc/pam.d/sshd

# Modify pam_radius_auth.conf
echo radius.dorayaki.org dorayaki 3 | tee -a /etc/pam_radius_auth.conf > /dev/null

# Modify common-auth
if ! grep -q "pam_radius_auth.so" /etc/pam.d/common-auth; then
	# Echo at first line
	sed -i '1s/^/auth sufficient pam_radius_auth.so\n/' /etc/pam.d/common-auth
fi

systemctl restart sshd