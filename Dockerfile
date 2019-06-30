FROM ubuntu:18.04

# Install proxy prerequisites
RUN apt-get update && apt-get -qy upgrade
RUN apt-get install -qy \
  iptables \
  redsocks

# Install docker-within-docker requirements
RUN apt-get install -qqy \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN apt-get update \
 && apt-get install -y docker-ce docker-ce-cli containerd.io
VOLUME /var/lib/docker

# Install docker-proxify
WORKDIR /proxy
ADD ./redsocks.conf /etc/redsocks.conf
ADD ./docker-redsocks /proxy/docker-redsocks
ADD ./docker-proxify-entrypoint /proxy/docker-proxify-entrypoint

# WORKDIR /app
CMD ["bash"]
ENTRYPOINT ["/proxy/docker-proxify-entrypoint"]
