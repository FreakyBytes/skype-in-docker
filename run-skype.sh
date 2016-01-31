#!/bin/sh
docker run -d -p 127.0.0.1:55757:22 --privileged -v /dev/video0:/dev/video0 --name skype-container docker-skype && \
  sleep 1 && \
  ssh -X -p 55757 -R 64713:localhost:4713 -i ~/.ssh/skype-on-docker docker@127.0.0.1 && \
  docker rm -f skype-container
