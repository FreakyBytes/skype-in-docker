#!/bin/bash

# set authorized keys
if [ "$SSHD_AUTHORIZED_KEYS" ]
then
	echo $SSHD_AUTHORIZED_KEYS > /root/.ssh/authorized_keys
	echo $SSHD_AUTHORIZED_KEYS > /home/docker/authorized_keys
fi

# start sshd
/usr/sbin/sshd -D
