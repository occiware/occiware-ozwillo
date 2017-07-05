#!/bin/sh

# Uninstall unnecessary software
apt-get purge -y vim \
   && apt-get autoremove -y

# Change Tomcat's default port from 8080 to 8088
sed -i 's/8088/8080/g' /usr/local/tomcat/conf/server.xml
