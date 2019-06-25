#
# redsocks Dockerfile
#
# https://github.com/wtsi-hgi/redsocks
FROM ubuntu:18.04 AS redsocks

# Install prerequisites
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y iptables make gcc libevent-dev

# Install redsocks source from git tree
ADD ./redsocks /usr/src/redsocks
WORKDIR /usr/src/redsocks

# Compile redsocks and install it in /usr/local/sbin
RUN make && cp redsocks /usr/local/sbin/redsocks

#
# Docker-proxify Dockerfile
#
# https://github.com/wtsi-hgi/docker-proxify
FROM redsocks

# Install docker-within-docker requirements
RUN apt-get update && apt-get install -qqy ca-certificates lxc aufs-tools git docker
VOLUME /var/lib/docker

# Install docker-proxify
ADD ./docker-proxify /usr/local/bin/docker-proxify
ADD ./docker-proxify-daemon /usr/local/bin/docker-proxify-daemon
ADD ./docker-in-docker-setup /usr/local/bin/docker-in-docker-setup
ADD ./docker-proxify-entrypoint /usr/local/bin/docker-proxify-entrypoint
RUN chmod +x /usr/local/bin/docker-*

RUN mkdir /docker
WORKDIR /docker
CMD ["bash"]
ENTRYPOINT ["/usr/local/bin/docker-proxify-entrypoint"]
