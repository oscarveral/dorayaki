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

apt-get install mailutils postfix -y

rm /etc/postfix/sasl/smtpd.conf
touch /etc/postfix/sasl/smtpd.conf

echo "pwcheck_method: saslauthd" >> /etc/postfix/sasl/smtpd.conf
echo "mech_list: plain login" >> /etc/postfix/sasl/smtpd.conf

apt-get install libsasl2-2 sasl2-bin libsasl2-modules -y

sed -i 's/START=no/START=yes/' /etc/default/saslauthd
echo "PWDIR=\"/var/spool/postfix/var/run/saslauthd\"" >> /etc/default/saslauthd
echo "PARAMS=\"-m ${PWDIR}\"" >> /etc/default/saslauthd
echo "PIDFILE=\"${PWDIR}/saslauthd.pid\"" >> /etc/default/saslauthd
sed -i 's/OPTIONS="-c -m \/var\/run\/saslauthd"/OPTIONS="-c -m \/var\/spool\/postfix\/var\/run\/saslauthd"/' /etc/default/saslauthd

dpkg-statoverride --force --update --add root sasl 755 /var/spool/postfix/var/run/saslauthd

sudo ln -s /etc/default/saslauthd /etc/saslauthd

/etc/init.d/saslauthd start
/etc/init.d/postfix restart

apt-get install dovecot-core dovecot-imapd -y

chmod +x /var/mail

userdel oscar
useradd -m -s /bin/bash -G mail oscar
passwd oscar

userdel carlos
useradd -m -s /bin/bash -G mail carlos
passwd carlos