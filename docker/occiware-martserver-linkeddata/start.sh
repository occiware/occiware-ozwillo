#!/bin/sh

# Workaround for Docker Studio since it doesn't support the --add-host parameter yet :
# Add datacore container IP to /etc/hosts file so that the datacore be able to connect with it
echo 172.17.0.5 ozwillo-datacore-1 >> /etc/hosts

export MAVEN_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,address=9000,server=y,suspend=n"

# Start the MartServer
mvn exec:java -e -X -Dexec.args=martserver.config -Dorg.eclipse.jetty.annotations.maxWait=120

