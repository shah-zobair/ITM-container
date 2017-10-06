FROM bac/rhel7

MAINTAINER Shah Zobair <szobair@redhat.com>

RUN echo "yum-master.example.com" > /etc/yum/vars/build_server && \
    echo "rhel7-latest" > /etc/yum/vars/buildtag && \
    echo "prod" > /etc/yum/vars/environment && \
    echo "latest" > /etc/yum/vars/patchlevel

ADD files/container.repo /etc/yum.repos.d/

RUN yum update -y && \
    yum install -y net-tools nmap tar ksh hostname atomic-openshift-clients && yum clean all

RUN rm -fr /ITM && \
    mkdir /ITM

ADD files/install_agents.sh /ITM/
COPY files/ITM.tar.gz /ITM/ITM.tar.gz

RUN mkdir -p /tools/tivoli/ITM && \
    chmod -R 777 /tools && \
    ln -s /host/root/.kube /root/.kube && \
    /ITM/install_agents.sh

ADD files/run.sh /

ENTRYPOINT /run.sh && /bin/bash
