FROM ubuntu:latest

# Setting root password
WORKDIR /
USER root
RUN echo 'root:streambox' | chpasswd

# Installation of required packages
RUN apt update -y && apt-get upgrade -y
RUN apt install curl vim wget bash -y

RUN wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
RUN echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
RUN echo ' \n\
Package: * \n\
Pin: origin packages.mozilla.org \n\
Pin-Priority: 1000' | tee /etc/apt/preferences.d/mozilla

RUN apt update
RUN apt install firefox -y

RUN apt install xvfb x11vnc i3-wm -y


RUN groupadd -g 445 onion
RUN useradd aqua -u 445 -g 445 -m -d /home/aqua -s /bin/bash
RUN echo 'aqua:minato' | chpasswd

WORKDIR /home/aqua/
USER aqua:445
ENTRYPOINT [ "bash" ]


# TODO:
# make it so that xvfb, x11vnc and firefox starts automatically upon container start

# export DISPLAY=:1
# Xvfb :1 -screen scrn 1280x768x16 &
# x11vnc -display :1 -N -forever &
# i3 &
# firefox &