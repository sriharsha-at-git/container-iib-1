FROM ubuntu:base

MAINTAINER Sriharsha@inthubss.com

# Install IIB V10 Developer edition
# curl http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/integration/10.0.0.8-IIB-LINUX64-DEVELOPER.tar.gz \
RUN mkdir /opt/ibm/ && \
	cd /opt/ibm/ && \
    curl ftp://ftpuser:ftpuser@127.0.0.1/10.0.0.8-IIB-LINUX64-DEVELOPER.tar.gz -o /opt/ibm/10.0.0.8-IIB-LINUX64-DEVELOPER.tar.gz && \
    tar -zxf /opt/ibm/10.0.0.8-IIB-LINUX64-DEVELOPER.tar.gz --exclude iib-10.0.0.8/tools --directory /opt/ibm && \
    /opt/ibm/iib-10.0.0.8/iib make registry global accept license silently

# Configure system
COPY kernel_settings.sh /tmp/
RUN echo "IIB_10:" > /etc/debian_chroot  && \
    touch /var/log/syslog && \
    chown syslog:adm /var/log/syslog && \
    dos2unix tmp/kernel_settings.sh && \
	chmod +x /tmp/kernel_settings.sh;sync && \
    /tmp/kernel_settings.sh


# Create user for iib to run as
RUN useradd --create-home --home-dir /home/iibuser -G mqbrkrs,sudo iibuser && echo 'iibuserpwd\niibuserpwd\n' | passwd iibuser && \
	useradd --create-home --home-dir /home/iibadmin -G mqbrkrs,sudo iibadmin && echo 'iibadminpwd\niibadminpwd\n' | passwd iibadmin && \
	sed -e 's/^%sudo	.*/%sudo	ALL=NOPASSWD:ALL/g' -i /etc/sudoers 

