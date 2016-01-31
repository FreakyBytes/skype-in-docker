#!/bin/sh
docker run -d -p 127.0.0.1:55757:22 --privileged -v /dev/video0:/dev/video0 --name skype-container docker-skype
