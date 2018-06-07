FROM ubuntu:16.04

RUN sed -i "s/# deb-src/deb-src/g" /etc/apt/sources.list && apt-get update \
    && apt install bash sudo curl wget -y && apt build-dep nginx -y

ARG PHP_UPSTREAM_CONTAINER=api-php-fpm
ARG PHP_UPSTREAM_PORT=9000

RUN wget https://ngxpagespeed.com/install && chmod 700 install && bash install \
     --nginx-version "1.14.0" \
     --dynamic-module \
     -y \
     -a '--prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt="-DNGX_HTTP_HEADERS"'

COPY builds/secondpage-api/pagespeed/nginx /etc/nginx
COPY builds/secondpage-api/pagespeed/nginx.conf /etc/nginx/
COPY ./secondpage-api /var/www
COPY builds/secondpage-api/pagespeed/sites /etc/nginx/sites-available

RUN echo "upstream php-upstream { server ${PHP_UPSTREAM_CONTAINER}:${PHP_UPSTREAM_PORT}; }" > /etc/nginx/conf.d/upstream.conf \
    && rm /etc/nginx/conf.d/default.conf

RUN mkdir /tmp/ngx_pagespeed_cache && mkdir /var/cache/nginx/

CMD ["nginx"]

EXPOSE 80 443
