FROM kalilinux/kali-linux-docker
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y && \
apt-get install -y \
net-tools \
openbox \
git \
x11vnc \
xvfb \
wget \
python \
python-numpy \
unzip \
geany \
iceweasel
menu && \
cd /root && git clone https://github.com/kanaka/noVNC.git && \
cd noVNC/utils && git clone https://github.com/kanaka/websockify websockify && \
cd /root
ADD startup.sh /startup.sh
RUN chmod 0755 /startup.sh && \
apt-get autoremove && \
rm -rf /var/lib/apt/lists/*

#The Kali Docker Image Is Out Of Date. : (
RUN apt-get update -y && apt-get dist-upgrade -y

CMD /startup.sh
and the startup.sh
#!/bin/bash
export DISPLAY=:1
Xvfb :1 -screen 0 1600x900x16 &
sleep 5
openbox-session&
x11vnc -display :1 -nopw -listen localhost -xkb -ncache 10 -ncache_cr -forever &
cd /root/noVNC && ln -s vnc_auto.html index.html && ./utils/launch.sh --vnc localhost:5900
