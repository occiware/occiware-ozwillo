#!/bin/sh

# Install necessary packages
apt-get update \
   && apt-get install -y --no-install-recommends vim \
   && rm -rf /var/lib/apt/lists/*

# Change Tomcat's default port from 8080 to 8088
sed -i 's/8080/8088/g' /usr/local/tomcat/conf/server.xml
