#Purpose: Installing Kali GUI in docker
From kalilinux/kali-rolling
#RUN apt-get install apt-utils -y
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Asia/Kolkata DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt install tzdata -y && apt install net-tools vim man file -y
RUN apt-get install kali-linux-headless -y
RUN  apt-get install -y vim perl wget tar man sudo adduser netstat-nat net-tools curl w3m
RUN useradd -m  -s /bin/bash kali
RUN usermod -aG sudo kali && echo "kali ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/kali
RUN chmod 044 /etc/sudoers.d/kali
USER kali:kali
WORKDIR /home/kali
#browser implementation
RUN apt-get install openssl shellinabox -y
#RUN echo -e "# TCP port that shellinboxd's webserver listens on\nSHELLINABOX_PORT=443\n#specify the IP address of a destination SSH server\nSHELLINABOX_ARGS=\"--o-beep -s /:SSH:192.168.1.7\"\n# if you want to restrict access to shellinaboxd from localhost only\nSHELLINABOX_ARGS=\"--o-beep -s /:SSH:192.168.1.7 --localhost-only"\" >> /etc/default/shellinabox
CMD ["/bin/bash"]
#docker run -itd --privileged #type_here_target_image_id /usr/sbin/init #command to run systemctl inside docker container
