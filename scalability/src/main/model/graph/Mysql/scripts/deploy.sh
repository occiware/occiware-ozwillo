#!/bin/bash

apt-get update

# MySQL prompts for a root password twice
# (2 steps : "root_password" and "root_password_again").
# Provide it with "roboconf" as a password (change it if needed...)
debconf-set-selections <<< 'mysql-server mysql-server/root_password password roboconf'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password roboconf'
apt-get -y install mysql-server

service mysql stop

cp $ROBOCONF_FILES_DIR/my.cnf /etc/mysql/

