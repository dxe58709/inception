FROM debian:bookworm
RUN apt-get update \
    && apt-get -y install mariadb-server mariadb-client
RUN mkdir /run/mysqld \
    && chown mysql:mysql /run/mysqld \
    && chmod 755 /run/mysqld
RUN sed -i 's/bind-address            = 127\.0\.0\.1/bind-address            = 0\.0\.0\.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT [ "docker-entrypoint.sh" ]

STOPSIGNAL SIGQUIT

CMD [ "mariadbd", "--gdb" ]
