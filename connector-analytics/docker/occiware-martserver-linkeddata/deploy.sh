#!/bin/sh

# Install necessary packages
apt-get update \
   && apt-get install -y maven \
   && rm -rf /var/lib/apt/lists/*

# Get the MartServer, version 1.5 (which explains the git checkout)
cd /tmp
git clone https://github.com/occiware/MartServer.git
cd MartServer
git checkout 20b454504d91f6390afa37f0e5f62044ecad7726
mvn initialize
mvn clean install
cd /tmp
rm -rf MartServer

# Get the latest version of the Datacore
cd /tmp
git clone https://github.com/ozwillo/ozwillo-datacore.git
cd ozwillo-datacore
mvn clean install -DskipTests
cd /tmp
rm -rf ozwillo-datacore

# Get the LinkedData Extension and Connector
cd /tmp
git clone https://github.com/occiware/ecore.git
# ---- STARTOF : TO BE UPDATED WHEN LINKEDDATA CHANGES COMMITED TO ECORE ----
git clone https://github.com/xia0ben/occiware-ozwillo.git
cp -rf occiware-ozwillo/connector-analytics/org.occiware.clouddesigner.occi.linkeddata* ecore/clouddesigner/
# ---- ENDOF : TO BE UPDATED WHEN LINKEDDATA CHANGES COMMITED TO ECORE ----
cd ecore/clouddesigner/org.occiware.clouddesigner.parent
mvn clean install
cd /tmp
rm -rf occiware-ozwillo
rm -rf ecore
#cd ecore

# Build the app
cd /app
mvn clean install
