#!/bin/sh

# Install necessary packages
apt-get update \
   && apt-get install -y maven \
   && rm -rf /var/lib/apt/lists/*

# Get the MartServer, version 1.5 (which explains the git checkout)
cd /tmp
git clone https://github.com/occiware/MartServer.git
cd /tmp/MartServer
git checkout 20b454504d91f6390afa37f0e5f62044ecad7726
mvn initialize
mvn clean install

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
mvn clean install

# Destroy all dependency sources
rm -rf /tmp/*

# Build the app
cd /app
mvn clean install
