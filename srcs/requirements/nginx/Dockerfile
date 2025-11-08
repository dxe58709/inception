FROM debian:bookworm
RUN apt-get update \
    && apt-get -y install nginx openssl \
    && rm -rf /var/lib/apt/lists/*

# NGINX 設定ファイルをコピー
COPY default.conf /etc/nginx/conf.d/default.conf
COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

EXPOSE 443

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD ["nginx", "-g", "daemon off;"]
