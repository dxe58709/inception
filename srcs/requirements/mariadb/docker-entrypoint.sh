#!/bin/bash

if [ ! -d /var/lib/mysql/mysql ]; then
	echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    TEMP_FILE='/tmp/mysql-first-time.sql'
	if [ ! -e /run/secrets/mysql_root_password ]; then
		echo >&2 'Error: database is uninitialized MYSQL_ROOT_PASSWORD not set'
		exit 1
	fi
	cat <<- EOSQL > "$TEMP_FILE"
		DELETE FROM mysql.user;
		CREATE USER 'root'@'%' IDENTIFIED BY '$(cat /run/secrets/mysql_root_password)';
		GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
		DROP DATABASE IF EXISTS test;
	EOSQL
    if [ -n "$MYSQL_DATABASE" ]; then
		echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;" >> "$TEMP_FILE"
	fi
	if [ -n "$MYSQL_USER" ] && [ -e /run/secrets/mysql_password ]; then
		echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$(cat /run/secrets/mysql_password)';" >> "$TEMP_FILE"
		if [ "$MYSQL_DATABASE" ]; then
			echo "GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';" >> "$TEMP_FILE"
		fi
	fi
	echo 'FLUSH PRIVILEGES;' >> "$TEMP_FILE"
	set -- "$@" --init-file="$TEMP_FILE"
fi