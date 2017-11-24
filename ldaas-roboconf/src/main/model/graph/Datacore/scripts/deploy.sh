#!/bin/sh

export DEBIAN_FRONTEND=noninteractive

# Install necessary packages
apt-get update
apt-get install -y git maven
#apt-get install -y default-jdk
# else tomcat7 uses java7 :
ln -fs /usr/lib/jvm/java-8-openjdk-amd64 /usr/lib/jvm/default-java
apt-get install -y tomcat7

# stop before configuring
service tomcat7 stop
#export TOMCAT_HOME=/usr/local/tomcat
#export TOMCAT_CONF=$TOMCAT_HOME/conf
#export TOMCAT_BIN=$TOMCAT_HOME/bin
export TOMCAT_HOME=/var/lib/tomcat7
export TOMCAT_CONF=/etc/tomcat7
export TOMCAT_BIN=/usr/share/tomcat7/bin

# # Build the Datacore
cd /tmp
git clone https://github.com/ozwillo/ozwillo-datacore.git
cd /tmp/ozwillo-datacore

mvn clean install -DskipTests

# Move the binaries to the appropriate location
cp -R /tmp/ozwillo-datacore/ozwillo-datacore-web/target/datacore/. $TOMCAT_HOME/webapps/ROOT

# Copy the configuration files
cp -R $ROBOCONF_FILES_DIR/webapps $TOMCAT_HOME/
cp -R $ROBOCONF_FILES_DIR/bin/* $TOMCAT_BIN/

# Change Tomcat's default port from 8080 to 8088
#sed -i 's/8080/8088/g' $TOMCAT_CONF/server.xml

# Clean up
#apt-get purge -y git default-jdk maven
#apt autoremove -y
#rm -rf /root/.m2/*
#rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
