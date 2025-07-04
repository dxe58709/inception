#!/bin/bash

set -e

mysql -h "mariadb" -u "${MYSQL_USER}" -p"$(cat /run/secrets/mysql_password)" -e "exit"
if [ $? -ne 0 ]; then
    echo "Error: DB connection failure"
    exit 1
fi

if [ ! -d /var/www/html ]; then
    mkdir -p /var/www/html
    chown -R www-data:www-data /var/www/html
    chmod 1777 /var/www/html
fi
if [ ! -d /var/www/html/wordpress ]; then
    curl -sLO https://ja.wordpress.org/latest-ja.zip
    unzip -d /var/www/html latest-ja.zip
    chown -R www-data:www-data /var/www/html/wordpress
    mv /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
    cp /var/www/html/wordpress/wp-config.php /var/www/html/wordpress/wp-config-sample.php.bak
    sed -i "s|^define( 'DB_NAME', 'database_name_here' );|define( 'DB_NAME', '$MYSQL_DATABASE' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'DB_USER', 'username_here' );|define( 'DB_USER', '$MYSQL_USER' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'DB_PASSWORD', 'password_here' );|define( 'DB_PASSWORD', '$(cat /run/secrets/mysql_password)' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'DB_HOST', 'localhost' );|define( 'DB_HOST', 'mariadb' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'AUTH_KEY',         'put your unique phrase here' );|define( 'AUTH_KEY',         '$(openssl rand -hex 20)' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );|define( 'SECURE_AUTH_KEY',  '$(openssl rand -hex 20)' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'LOGGED_IN_KEY',    'put your unique phrase here' );|define( 'LOGGED_IN_KEY',    '$(openssl rand -hex 20)' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'NONCE_KEY',        'put your unique phrase here' );|define( 'NONCE_KEY',        '$(openssl rand -hex 20)' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'AUTH_SALT',        'put your unique phrase here' );|define( 'AUTH_SALT',        '$(openssl rand -hex 20)' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );|define( 'SECURE_AUTH_SALT', '$(openssl rand -hex 20)' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'LOGGED_IN_SALT',   'put your unique phrase here' );|define( 'LOGGED_IN_SALT',   '$(openssl rand -hex 20)' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'NONCE_SALT',       'put your unique phrase here' );|define( 'NONCE_SALT',       '$(openssl rand -hex 20)' );|g" /var/www/html/wordpress/wp-config.php
    chmod 1777 /var/www/html/wordpress
    if [ -e /run/secrets/wp_credentials ]; then
        set -a
        source /run/secrets/wp_credentials
        set +a
    fi

    if [ -n "$DOMAIN_NAME" ] && [ -n "$WP_TITLE" ] && [ -n "$WP_ADMIN" ] && [ -n "$WP_ADMIN_PASSWORD" ] && [ -n "$WP_ADMIN_EMAIL" ]; then
        wp core install --url="https://${DOMAIN_NAME}/" --title="${WP_TITLE}" --admin_user="${WP_ADMIN}" --admin_password="${WP_ADMIN_PASSWORD}" --admin_email="${WP_ADMIN_EMAIL}" --path="/var/www/html/wordpress" --allow-root
    fi
    if [ -n "$WP_USERNAME" ] && [ -n "$WP_EMAIL" ] && [ -n "$WP_PASSWORD" ] && [ -n "$WP_DISPLYNAME" ]; then
        wp user create "$WP_USERNAME" "$WP_EMAIL" --role=author --user_pass="$WP_PASSWORD" --display_name="$WP_DISPLYNAME" --path="/var/www/html/wordpress" --allow-root
    fi
fi

exec "$@"