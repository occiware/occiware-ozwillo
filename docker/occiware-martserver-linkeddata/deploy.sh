#!/bin/sh

# Install necessary packages
apt-get update
apt-get install -y maven
rm -rf /var/lib/apt/lists/*

# Get the MartServer, version 1.5 (which explains the git checkout)
cd /tmp
git clone https://github.com/occiware/MartServer.git
cd /tmp/MartServer
git checkout 543e6d9c97b23a8a0e3d0152b557b7f8e4f5ecb3
mvn initialize
mvn clean install -DskipTests

# Get the LinkedData Extension and Connector
cd /tmp
git clone https://github.com/occiware/ecore.git
git checkout ldnodeintegration
# Change to appropriate datacoreApiClient.baseUrl value for demo
sed -i 's/datacoreApiClient.baseUrl=http\:\/\/localhost\:8088/datacoreApiClient.baseUrl=http\:\/\/ozwillo-datacore-1\:8088/g' /tmp/ecore/clouddesigner/org.occiware.clouddesigner.occi.linkeddata.connector/src/oasis-datacore-rest-client-custom.properties
sed -i 's/private static final boolean IS_MARTSERVER = false/private static final boolean IS_MARTSERVER = true/g' /tmp/ecore/clouddesigner/org.occiware.clouddesigner.occi.linkeddata.connector/src/org/occiware/clouddesigner/occi/linkeddata/connector/LdnodeConnector.java
cd /tmp/ecore/clouddesigner/org.occiware.clouddesigner.parent
mvn clean install -DskipTests

# Destroy all dependency sources
rm -rf /tmp/*

# Build the app
cd /app
mvn clean install
