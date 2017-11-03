#!/bin/bash

SSH_KEY_NAME="skype-container"
CONTAINER_NAME="skype-container"

# function to stop/remove container
function container-stop {
	docker stop $CONTAINER_NAME
}

# create keys dir
mkdir keys || true

if [ ! -f keys/${SSH_KEY_NAME} ]
then
	# generate new keys, since they do not exists
	(cd keys && ssh-keygen -b 4096 -N "" -f $SSH_KEY_NAME)
fi

# start container
docker run -d --rm -p 127.0.0.1:55757:22 --privileged -v /dev/video0:/dev/video0 -e "SSHD_AUTHORIZED_KEYS=$(cat keys/${SSH_KEY_NAME}.pub)" --name $CONTAINER_NAME pulse-skype:latest || exit 1

# sleep a while aka. wait until container is up and running
sleep 1
ssh -X -p 55757 -i keys/${SSH_KEY_NAME} docker@127.0.0.1

# clean up
ssh-keygen -f "/home/martin/.ssh/known_hosts" -R "[127.0.0.1]:55757"
container-stop
