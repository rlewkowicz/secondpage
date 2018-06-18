#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


#Api
(docker build -f builds/secondpage-api/pagespeed/Dockerfile . -t rlewkowicz/api:pagespeed-1.0.0 &) &
(docker build -f builds/secondpage-api/nginx/Dockerfile . -t rlewkowicz/api:nginx-1.0.0 &) &
(docker build -f builds/secondpage-api/php-fpm/Dockerfile . -t rlewkowicz/api:php-fpm-1.0.0 &) &

#rssparse
(docker build -f builds/secondpage-rssparse/php-fpm/Dockerfile . -t rlewkowicz/rssparse:php-fpm-1.0.0 &) &
(docker build -f builds/secondpage-rssparse/nginx/Dockerfile . -t rlewkowicz/rssparse:nginx-1.0.0 &) &

#pythonutils
(
sed -i "s/ENV=.*/ENV=dev/g" $DIR/secondpage-pythonutils/.env && \
docker build -f $DIR/builds/secondpage-pythonutils/Dockerfile . -t rlewkowicz/pythonutils:1.0.0 && \
sed -i "s/ENV=.*/ENV=sb/g" $DIR/secondpage-pythonutils/.env && \
docker build -f $DIR/builds/secondpage-pythonutils/Dockerfile . -t rlewkowicz/pythonutils:1.0.0-sb
) &


#spark
(docker build -f builds/secondpage-spark/Dockerfile . -t rlewkowicz/spark &) &


#render
(docker build -f builds/secondpage-render/Dockerfile . -t rlewkowicz/render &) &
