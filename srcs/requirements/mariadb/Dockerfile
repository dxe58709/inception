FROM debian:bullseye
RUN apt-get update \
    && apt-get -y install mariadb-server mariadb-client
RUN mkdir /run/mysqld \
    && chown mysql:mysql /run/mysqld && chmod 755 /run/mysqld 

STOPSIGNAL SIGQUIT
ENTRYPOINT [ "" ]
CMD [ "mariadbd", "--gdb" ]