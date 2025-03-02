#!/bin/bash

if [ ! -d /var/lib/mysql/mysql ]; then
	echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql