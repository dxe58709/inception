FROM debian:bullseye
RUN apt-get update \
    && apt-get -y install nginx openssl \
    && rm -rf /var/lib/apt/lists/*
    
# TLS 証明書の作成（自己署名）
RUN mkdir -p /etc/nginx/ssl \
    && openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt \
    -subj "/C=JP/ST=Tokyo/L=Kawasaki/O=42/OU=Dev/CN=nsakanou.42.fr"
    
# NGINX 設定ファイルをコピー
COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]