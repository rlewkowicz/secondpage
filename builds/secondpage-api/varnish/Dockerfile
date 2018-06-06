FROM debian:jessie

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive

ADD https://gist.githubusercontent.com/rlewkowicz/d60e62831b71fbb0e2aa4cddd9a94dfa/raw/2f589593d8c840bd267daab1a80159d5c7bee5bc/jessie-src.list /etc/apt/sources.list.d/jessie-src.list

# Install Dependencies
RUN apt-get update && apt-get install -y apt-utils && apt-get upgrade -y
RUN mkdir /home/site && mkdir /home/site/cache && \
apt-get install -y wget curl vim && \
apt-get build-dep varnish -y && \
rm -rf /var/lib/apt/lists/*

RUN wget https://varnish-cache.org/_downloads/varnish-4.1.10.tgz && tar -xzf varnish-4.1.10.tgz && \
cd varnish-4.1.10 && bash autogen.sh && ./configure && make -j6 && make install

# Setting Configurations
ENV VARNISH_CONFIG  /etc/varnish/default.vcl
ENV CACHE_SIZE      128m
ENV VARNISHD_PARAMS -p default_ttl=3600 -p default_grace=3600
ENV VARNISH_PORT    6081
ENV BACKEND_HOST    localhost
ENV BACKEND_PORT    80

COPY builds/secondpage-api/varnish/default.vcl /etc/varnish/default.vcl
COPY builds/secondpage-api/varnish/start.sh /etc/varnish/start.sh

RUN chmod +x /etc/varnish/start.sh

CMD ["/etc/varnish/start.sh"]

EXPOSE 8080
