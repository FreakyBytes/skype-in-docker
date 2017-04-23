FROM debian:stable
MAINTAINER Martin Peters <martin@freakybytes.net>
#
# based on https://www.dustri.org/b/running-skype-in-docker.html
# and https://github.com/binfalse/skype-on-docker
#

# Skype is i386 only
RUN dpkg --add-architecture i386
# update/upgrade system
RUN apt-get update -y && apt-get upgrade -y

# Create a docker:docker user
RUN useradd -m -d /home/docker -s /bin/bash docker && \
    mkdir -p /var/run/sshd \
             /root/.ssh /home/docker/.ssh
# Install dependencies:
#  openssh-server as we connect to the container via SSH
#  wget to download skype
#  xauth for x forwarding
RUN apt-get install -y --no-install-recommends \
        openssh-server \
        wget \
        xauth \
	libpulse0:i386 pulseaudio:i386

# Install Skype
RUN wget http://download.skype.com/linux/skype-debian_4.3.0.37-1_i386.deb -O /usr/src/skype.deb && \
    echo 'a820e641d1ee3fece3fdf206f384eb65e764d7b1ceff3bc5dee818beb319993c  /usr/src/skype.deb' | sha256sum -c
RUN dpkg -i /usr/src/skype.deb || true
RUN apt-get install -fy && rm /usr/src/skype.deb

# Configure SSH stuff
RUN echo X11Forwarding yes >> /etc/ssh/ssh_config
COPY authorized_keys /root/.ssh/
COPY authorized_keys /home/docker/.ssh/

# Exposes the ssh port
EXPOSE 22

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
# SSH, Public Key and Skype are already setup in skype-on-docker
CMD ["/usr/sbin/sshd", "-D"]
