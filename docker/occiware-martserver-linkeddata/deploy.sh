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

# Get the latest version of the Datacore
cd /tmp
git clone https://github.com/ozwillo/ozwillo-datacore.git
cd /tmp/ozwillo-datacore
mvn clean install -DskipTests

# Get the LinkedData Extension and Connector
cd /tmp
# ---- STARTOF : TO BE UPDATED WHEN LINKEDDATA CHANGES COMMITED TO ECORE ----
git clone https://github.com/xia0ben/ecore.git
# ---- ENDOF : TO BE UPDATED WHEN LINKEDDATA CHANGES COMMITED TO ECORE ----
cd /tmp/ecore/clouddesigner/org.occiware.clouddesigner.parent
mvn clean install -DskipTests

# Destroy all dependency sources
rm -rf /tmp/*

# Build the app
cd /app
mvn clean install
