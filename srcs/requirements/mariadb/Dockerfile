FROM debian:bullseye
RUN apt-get update \
    && apt-get -y install mariadb-server mariadb-client
RUN mkdir /run/mysqld \
    && chown mysql:mysql /run/mysqld && chmod 755 /run/mysqld 

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT [ "docker-entrypoint.sh" ]

STOPSIGNAL SIGQUIT

CMD [ "mariadbd", "--gdb" ]