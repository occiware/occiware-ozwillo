#!/bin/sh

# Workaround for Docker Studio since it doesn't support the --add-host parameter yet :
# Add mongo containers IPs to /etc/hosts file so that the datacore be able to connect with them
echo 172.17.0.5 ozwillo-datacore-1 >> /etc/hosts

# Start the Tomcat webserver
cd /app/ozwillo-ozenergy/ozwillo-ozenergy-data
mvn clean test -Dtest=DatacoreEnergyImportClientTest

while :; do sleep 100; done
