#!/bin/sh

# Workaround for Docker Studio since it doesn't support the --add-host parameter yet :
# Add mongo containers IPs to /etc/hosts file so that the datacore be able to connect with them
echo 172.17.0.5 ozwillo-datacore-1 >> /etc/hosts

# Start postgresql TODO DO IN BACK
su -s /bin/bash postgres
/usr/lib/postgresql/9.6/bin/postgres -D /var/lib/postgresql/9.6/main -c config_file=/etc/postgresql/9.6/main/postgresql.conf >/dev/null 2>&1 &
exit

# Start Blynk TODO DO IN BACK
java -jar /blynk/server.jar -dataFolder /data -serverConfig /config/server.properties >/dev/null 2>&1 &

# Start the Tomcat webserver
cd /app/ozwillo-ozenergy/ozwillo-ozenergy-data
mvn clean test -Dtest=DatacoreEnergyBridgeClientTest
