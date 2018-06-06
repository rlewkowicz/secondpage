FROM nginx:1.14.0

COPY builds/secondpage-api/nginx/nginx.conf /etc/nginx/
COPY ./secondpage-api /var/www
COPY builds/secondpage-api/nginx/sites /etc/nginx/sites-available

# If you're in China, or you need to change sources, will be set CHANGE_SOURCE to true in .env.

ARG CHANGE_SOURCE=false
RUN if [ ${CHANGE_SOURCE} = true ]; then \
    # Change application source from dl-cdn.alpinelinux.org to aliyun source
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
;fi

RUN apt-get update \
    && apt install bash 

ARG PHP_UPSTREAM_CONTAINER=api-php-fpm
ARG PHP_UPSTREAM_PORT=9000

# Set upstream conf and remove the default conf
RUN echo "upstream php-upstream { server ${PHP_UPSTREAM_CONTAINER}:${PHP_UPSTREAM_PORT}; }" > /etc/nginx/conf.d/upstream.conf \
    && rm /etc/nginx/conf.d/default.conf

COPY builds/secondpage-api/pagespeed/ngx_pagespeed.so /etc/nginx/modules/ngx_pagespeed.so

RUN mkdir /tmp/ngx_pagespeed_cache

CMD ["nginx"]

EXPOSE 80 443