FROM debian:stable
MAINTAINER Martin Peters <martin@freakybytes.net>
#
# based on https://www.dustri.org/b/running-skype-in-docker.html
# and https://github.com/binfalse/skype-on-docker
#

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
        wget ca-certificates \
        xauth \
	xpra \
	libpulse0 pulseaudio

# Install Skype
RUN wget https://go.skype.com/skypeforlinux-64.deb -O /tmp/skypeforlinux.deb && \
    echo 'b412a1aa8c25d624e8778c81cc276fe61015f548015d459f92020b0b7a3068a3  /tmp/skypeforlinux.deb' | sha256sum -c
#RUN wget http://download.skype.com/linux/skype-debian_4.3.0.37-1_i386.deb -O /usr/src/skype.deb && \
#    echo 'a820e641d1ee3fece3fdf206f384eb65e764d7b1ceff3bc5dee818beb319993c  /usr/src/skype.deb' | sha256sum -c
RUN dpkg -i /tmp/skypeforlinux.deb || true
RUN apt-get install -fy && rm /tmp/skypeforlinux.deb

# Configure SSH stuff
RUN echo X11Forwarding yes >> /etc/ssh/ssh_config
COPY authorized_keys /root/.ssh/
COPY authorized_keys /home/docker/.ssh/

# Write launch script for skype with pulseadio support and set permission
RUN echo '#!/bin/bash \n \
export PULSE_SERVER="tcp:locahost:64713" \n \
export PULSE_LATENCY_MSEC=60 \n \
skypeforlinux' > /usr/local/bin/run-skype && chmod 755 /usr/local/bin/run-skype

# add config entry to pulseaudio config
RUN echo 'default-server=localhost:64713' >> /etc/pulse/client.conf

# Expose SSH port
EXPOSE 22

# start SSHd
# SSH, Public Key and Skype are already setup in skype-on-docker
CMD ["/usr/sbin/sshd", "-D"]
