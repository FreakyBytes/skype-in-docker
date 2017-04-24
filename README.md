Skype in Docker
===============

This is [Docker](https://docker.com) image to run the newest version of [Skype](https://www.skype.com), so it is isolated from the rest of your system.
It requires you to have [PulseAudio](https://www.freedesktop.org/wiki/Software/PulseAudio/) installed and running on your host system. Further you need to activate network access without password in PulseAudio.

You may need to initially build the image by running:

```
docker build -t pulse-skype:latest .
```

Running Skype
-------------

To run Skype simply execute `./run-skype.sh`. This script will create a new pair of SSH keys, if necessary, starts the container and connects to the SSHd server in it.
In this command line you now can run `skypeforlinux` to start skype.
