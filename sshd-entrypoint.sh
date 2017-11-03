#!/bin/bash

PULSE_SERVER="$(ip route | grep default | cut -d' ' -f 3):4713"

# set authorized keys
if [ "$SSHD_AUTHORIZED_KEYS" ]
then
	echo $SSHD_AUTHORIZED_KEYS > /root/.ssh/authorized_keys
	echo $SSHD_AUTHORIZED_KEYS > /home/docker/.ssh/authorized_keys
fi

echo "PULSE_SERVER=${PULSE_SERVER}" >> /home/docker/.ssh/environment

# start sshd
/usr/sbin/sshd -D
