#!/bin/sh
#Api
(docker build -f builds/secondpage-api/nginx/Dockerfile . -t rlewkowicz/api:nginx-1.0.0 &) &
(docker build -f builds/secondpage-api/php-fpm/Dockerfile . -t rlewkowicz/api:php-fpm-1.0.0 &) &

#rssparse
(docker build -f builds/secondpage-rssparse/php-fpm/Dockerfile . -t rlewkowicz/rssparse:php-fpm-1.0.0 &) &
(docker build -f builds/secondpage-rssparse/nginx/Dockerfile . -t rlewkowicz/rssparse:nginx-1.0.0 &) &

#pythonutils
(docker build -f builds/secondpage-pythonutils/Dockerfile . -t rlewkowicz/python-utils-1.0.0 &) &

#spark
(docker build -f builds/secondpage-spark/Dockerfile . -t spark &) &


#render
(docker build -f builds/secondpage-render/Dockerfile . -t render &) &
