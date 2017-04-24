#!/bin/sh
docker run -d --rm -p 127.0.0.1:55757:22 --privileged -v /dev/video0:/dev/video0 --name skype-container pulse-skype:latest && \
  sleep 1 && \
  ssh -X -p 55757 -R 64713:localhost:4713 -i ~/.ssh/skype-on-docker docker@127.0.0.1 && \
  docker stop skype-container
