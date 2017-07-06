FROM ubuntu:14.04

MAINTAINER Sriharsha@inthubss.com

# Install curl
RUN apt-get update && \
    apt-get install -y curl dos2unix && \
    rm -rf /var/lib/apt/lists/*

# Configure system
COPY kernel_settings.sh /tmp/
RUN dos2unix tmp/kernel_settings.sh && \
	chmod +x /tmp/kernel_settings.sh;sync && \
    /tmp/kernel_settings.sh
