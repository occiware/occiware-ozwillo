#!/bin/sh

# Install necessary packages
apt-get update \
   && apt-get install -y maven \
   && rm -rf /var/lib/apt/lists/*

# Get the MartServer
cd /tmp
git clone https://github.com/occiware/MartServer.git
cd MartServer
git checkout 20b454504d91f6390afa37f0e5f62044ecad7726
mvn initialize
mvn clean install
cd ..
rm -rf MartServer

# Get the LinkedData Connector and
cd /tmp
git clone https://github.com/occiware/Ecore.git
