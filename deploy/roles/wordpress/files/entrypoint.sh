#!/bin/bash

mkdir -p /run/php

if ! wp core is-installed --allow-root >> /dev/null 2>&1; then
    echo "Downloading core WordPress files"
    wp core download --allow-root

    echo "Generate the wp-config.php file"
    wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD --dbhost=$DB_HOST --allow-root

    echo "Create WordPress database tables"
    wp core install --url=$DOMAIN_NAME --title=$WP_TITLE \
        --admin_user=$WP_ROOT --admin_password=$WP_ROOT_PASSWORD \
        --admin_email=$WP_ROOT_EMAIL --allow-root

    echo "Create WordPress user"
    wp user create $WP_USER $WP_EMAIL --user_pass=$WP_PASSWORD \
        --role=author --allow-root
fi

exec "$@"