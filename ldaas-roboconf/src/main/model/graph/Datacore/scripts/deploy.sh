#!/bin/sh

# Install necessary packages
apt-get update
apt-get install -y git default-jdk maven

# # Build the Datacore
cd /tmp
git clone https://github.com/ozwillo/ozwillo-datacore.git
cd /tmp/ozwillo-datacore

mvn clean install -DskipTests

# Move the binaries to the appropriate location
cp -R /tmp/ozwillo-datacore/ozwillo-datacore-web/target/datacore/. /usr/local/tomcat/webapps/ROOT

# Change Tomcat's default port from 8080 to 8088
sed -i 's/8080/8088/g' /usr/local/tomcat/conf/server.xml

# Clean up
apt-get purge -y git default-jdk maven
apt autoremove -y
rm -rf /root/.m2/*
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
