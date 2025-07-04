FROM debian:bullseye

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y unzip curl php-fpm php-mysql php-gd php-cli php-mbstring mariadb-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /run/php
RUN cp /etc/php/7.4/fpm/pool.d/www.conf /etc/php/7.4/fpm/pool.d/www.conf.bak
RUN sed -i 's|^listen = /run/php/.*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i '/^listen.owner = www-data/d' /etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i '/^listen.group = www-data/d' /etc/php/7.4/fpm/pool.d/www.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

ARG TIMESTAMP=
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

STOPSIGNAL SIGQUIT
EXPOSE 9000

CMD [ "php-fpm7.4", "-F" ]