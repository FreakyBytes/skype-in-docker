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
	libpulse0 pulseaudio

# Install Skype
# https://go.skype.com/skypeforlinux-64.deb
RUN wget https://go.skype.com/skypeforlinux-64.deb -O /tmp/skypeforlinux.deb && \
    echo 'd09152d1eabd57d75346eda8ab91ddb8c48d275a292ae5a2f18e179ccadc2bb7  /tmp/skypeforlinux.deb' | sha256sum -c
RUN dpkg -i /tmp/skypeforlinux.deb || true
RUN apt-get install -fy && rm /tmp/skypeforlinux.deb

# Configure SSH stuff
RUN echo "X11Forwarding yes" >> /etc/ssh/ssh_config && \
    echo "X11UseLocalhost no \nPermitUserEnvironment yes" >> /etc/ssh/sshd_config

# env var containing authorized ssh keys
ENV SSHD_AUTHORIZED_KEYS=""

# set pulse config vars on ssh login
RUN echo '\
PULSE_LATENCY_MSEC=60' > /home/docker/.ssh/environment

COPY sshd-entrypoint.sh /sshd-entrypoint.sh

# add config entry to pulseaudio config
RUN echo 'default-server=localhost:4713' >> /etc/pulse/client.conf

# Expose SSH port
EXPOSE 22

# start SSHd
# SSH, Public Key and Skype are already setup in skype-on-docker
CMD ["/sshd-entrypoint.sh"]
