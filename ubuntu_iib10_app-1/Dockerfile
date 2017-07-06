FROM ubuntu:iibv10

MAINTAINER Sriharsha@inthubss.com

RUN echo 'iibuserpwd\n' 

# Copy in script files
COPY iib_manage.sh /usr/local/bin/
COPY iib-license-check.sh /usr/local/bin/
COPY iib_env.sh /usr/local/bin/
COPY ./BARfiles/* /tmp/BARfiles/
RUN chmod +rx /usr/local/bin/*.sh && dos2unix /usr/local/bin/iib*.sh

# Set BASH_ENV to source mqsiprofile when using docker exec bash -c
ENV BASH_ENV=/usr/local/bin/iib_env.sh

# Expose default admin port and http port
EXPOSE 4414 7800

USER iibuser

# Set entrypoint to run management script
ENTRYPOINT ["iib_manage.sh"]
