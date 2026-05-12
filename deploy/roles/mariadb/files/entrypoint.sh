#!/bin/bash

# start mariadb service
echo "start mariadb service"
service mariadb start

echo "Waiting for mysqld to run..."
until mysqladmin ping -h localhost --silent; do
    sleep 1
    echo "Waiting for mysqld to run..."
done

echo "mysqld is running"

# create a regular mariadb user
echo "create database"
mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"

echo "create user"
mariadb -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@\`%\` IDENTIFIED BY '${MYSQL_PASSWORD}';"

echo "grant privileges"
mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO \`${MYSQL_USER}\`@\`%\`;"
mariadb -e "FLUSH PRIVILEGES;"

sleep 3

echo "stop mariadb"
service mariadb stop

exec "$@"