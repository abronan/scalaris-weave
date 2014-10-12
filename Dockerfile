# Scalaris Weave
# v0.1.0

FROM ubuntu:trusty

MAINTAINER Alexandre Beslic

# Install and setup project dependencies
RUN apt-get update && apt-get install -y erlang wget curl lsb-release supervisor openssh-server

RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor

RUN locale-gen en_US en_US.UTF-8

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN echo 'root:scalaris' | chpasswd

# Install and setup Scalaris
RUN echo "deb http://download.opensuse.org/repositories/home:/scalaris/xUbuntu_14.04/ ./" >> /etc/apt/sources.list
RUN wget -q http://download.opensuse.org/repositories/home:/scalaris/openSUSE_Factory/repodata/repomd.xml.key -O - | sudo apt-key add -

RUN apt-get update && apt-get install -y scalaris

ADD ./scalaris-run.sh /bin/scalaris-run.sh
RUN chmod +x /bin/scalaris-run.sh

EXPOSE 22

CMD ["/usr/bin/supervisord"]
