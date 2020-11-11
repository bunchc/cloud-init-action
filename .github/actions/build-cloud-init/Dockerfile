FROM centos:7

# Working directory
WORKDIR /root

# Download required packages
RUN yum -y install vim wget tar openssl python-lxml glibc.i686 git file
RUN rpm --rebuilddb \
    && yum clean all \
    && yum update -y nss curl libcurl \
    && yum -y groupinstall "Development Tools" \
    && yum -y groupinstall "Additional Development" \
    && yum -y install epel-release \
    && yum -y install ansible \
    && yum clean all

COPY entrypoint.sh /entrypoint.sh
COPY playbooks/ /playbooks
COPY scripts/ /scripts
CMD ["/bin/bash"]
ENTRYPOINT ["/entrypoint.sh"]