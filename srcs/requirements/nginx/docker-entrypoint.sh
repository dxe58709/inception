#!/bin/bash

# TLS 証明書の作成（自己署名）
rm -rf /etc/nginx/ssl
mkdir -p /etc/nginx/ssl
openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt \
    -subj "/C=JP/ST=Tokyo/L=Kawasaki/O=42/OU=Dev/CN=nsakanou.42.fr"
    

exec "$@"
