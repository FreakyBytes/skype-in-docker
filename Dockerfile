FROM skype-on-docker
MAINTAINER Martin Peters <martin@freakybytes.net>

# SSH, Public Key and Skype are already setup in skype-on-docker

# Install pulseaudio (Audio Server) for i386
RUN apt-get install -y libpulse0:i386 pulseaudio:i386

# Write launch script for skype with pulseadio support and set permission
RUN echo '#!/bin/bash \
export PULSE_SERVER="tcp:locahost:64713" \
export PULSE_LATENCY_MSEC=60 \
skype' > /usr/local/bin/run-skype && chmod 755 /usr/local/bin/run-skype

# Expose SSH port
EXPOSE 22
