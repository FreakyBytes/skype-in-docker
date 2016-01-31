FROM skype-on-docker
MAINTAINER Martin Peters <martin@freakybytes.net>

# SSH, Public Key and Skype are already setup in skype-on-docker

# Install pulseaudio (Audio Server) for i386
RUN apt-get install -y libpulse0:i386 pulseaudio:i386
#RUN apt-get install -y dbus libdbus-1-3

# Write launch script for skype with pulseadio support and set permission
RUN echo '#!/bin/bash \n \
export PULSE_SERVER="tcp:locahost:64713" \n \
export PULSE_LATENCY_MSEC=60 \n \
skype' > /usr/local/bin/run-skype && chmod 755 /usr/local/bin/run-skype

# add config entry to pulseaudio config
RUN echo 'default-server=localhost:64713' >> /etc/pulse/client.conf

# Expose SSH port
EXPOSE 22

# start SSHd
CMD ["/usr/sbin/sshd", "-D"]
