#!/usr/bin/env bash
set -e

for name in BACKEND_PORT BACKEND_HOST VARNISH_SERVER
do
    eval value=\$$name
    sed -i "s|\${${name}}|${value}|g" /etc/varnish/default.vcl
done

exec bash -c \
    "exec varnishd \
    -a :80 \
    -T localhost:6082 \
    -F \
    -f /etc/varnish/default.vcl \
    -s malloc,250M"
