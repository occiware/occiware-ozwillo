#!/bin/sh

# Workaround for Docker Studio since it doesn't support the --add-host parameter yet :
# Add datacore container IP to /etc/hosts file so that the datacore be able to connect with it
echo 172.17.0.5 ozwillo-datacore-1 >> /etc/hosts

# Start the MartServer
mvn exec:java -Dexec.args=martserver.config
