############################################################
# Dockerfile to build Uwsgi container images
# Based on Centos
############################################################
FROM centos:6.6
MAINTAINER Bogdan
#Set up Repos
RUN echo 0 >/selinux/enforce && \
    rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm && \
    sed -i 's/https/http/g' /etc/yum.repos.d/epel.repo
ADD ./RPM-GPG-KEY-puias /etc/pki/rpm-gpg/RPM-GPG-KEY-puias
ADD ./puias.repo /etc/yum.repos.d/puias.repo
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

RUN useradd test -d /home/test -U -u 500 -m -G wheel && \
    mkdir -p /home/test/.ssh && \
    echo "StrictHostKeyChecking no" > /home/test/.ssh/config
ADD ./id_rsa  /home/test/.ssh/id_rsa
RUN chmod 700 /home/test/.ssh/config && \
    chmod 600 /home/test/.ssh/id_rsa && \
    chmod 700 /home/test/.ssh
RUN yum -y update
RUN yum groupinstall -y "Development Tools" 
RUN yum -y install     \
                   tar \
                   wget \
                   python-2.7 \
                   python-2.7-devel \ 
                   lua-devel \
                   ruby \
                   ruby-devel \
                   rubygems
RUN gem install fpm
RUN ln -s /usr/bin/fpm /usr/local/bin/fpm
RUN echo "test ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers 
ADD ./build-*.sh /home/test/

RUN chown -R test:wheel /home/test/
RUN chmod -R 777 /home/test/build*
RUN less /etc/sudoers
USER test
CMD /bin/bash
