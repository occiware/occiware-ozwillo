#!/bin/sh

# Workaround for Docker Studio since it doesn't support the --add-host parameter yet :
# Add mongo containers IPs to /etc/hosts file so that the datacore be able to connect with them
#echo 172.17.0.2 ozwillo-mongo-1 >> /etc/hosts
#echo 172.17.0.3 ozwillo-mongo-2 >> /etc/hosts
#echo 172.17.0.4 ozwillo-mongo-3 >> /etc/hosts

# Start the Tomcat webserver
while true; do
    echo Hello World
    sleep 1
done
