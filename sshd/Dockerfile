#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#
# hhj - allows to ssh to workspace (uses sources volumes)
#
# To change its version, see the available Tags on the Docker Hub:
#    https://hub.docker.com/r/laradock/workspace/tags/
#

FROM laradock/workspace:1.1

MAINTAINER Jan Haering <hhj@centrum.cz>

#####################################
# Non-Root User:
#####################################

# Add a non-root user to prevent files being created with root permissions on host machine.
ARG PUID=1000
ARG PGID=1000
RUN groupadd -g $PGID laradock && \
    useradd -u $PUID -g laradock -m laradock

#####################################
# ssh:
#####################################

# Check if ssh needs to be installed
# See: https://github.com/phusion/baseimage-docker#enabling_ssh
# hhj - add authorized keys to laradock as well:
ADD insecure_id_rsa /tmp/id_rsa
ADD insecure_id_rsa.pub /tmp/id_rsa.pub
#ARG INSTALL_WORKSPACE_SSH=true
#ENV INSTALL_WORKSPACE_SSH ${INSTALL_WORKSPACE_SSH}
#RUN if [ ${INSTALL_WORKSPACE_SSH} = true ]; then \
RUN rm -f /etc/service/sshd/down && \
    cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys \
        && cat /tmp/id_rsa.pub >> /root/.ssh/id_rsa.pub \
        && cat /tmp/id_rsa >> /root/.ssh/id_rsa \
        && chmod 644 /root/.ssh/authorized_keys /root/.ssh/id_rsa.pub \
        && chmod 400 /root/.ssh/id_rsa \
        \
        && mkdir /home/laradock/.ssh \
        && cat /tmp/id_rsa.pub >> /home/laradock/.ssh/id_rsa.pub \
        && cat /tmp/id_rsa >> /home/laradock/.ssh/id_rsa \
        && cat /tmp/id_rsa.pub >> /home/laradock/.ssh/authorized_keys \
        && chown -R laradock.laradock /home/laradock/.ssh \
        && chmod 644 /home/laradock/.ssh/authorized_keys /home/laradock/.ssh/id_rsa.pub \
        && chmod 400 /home/laradock/.ssh/id_rsa \
        && rm -f /tmp/id_rsa*
#;fi

#
#--------------------------------------------------------------------------
# Final Touch
#--------------------------------------------------------------------------
#

# Clean up
USER root
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set default work directory
WORKDIR /var/www/app
