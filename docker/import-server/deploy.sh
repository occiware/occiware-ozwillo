#!/bin/sh

# Install necessary packages
apt-get update
apt-get install -y git default-jdk maven

# Build the the data project
cd /tmp
git clone https://github.com/ozwillo/ozwillo-ozenergy.git
cd /tmp/ozwillo-ozenergy/ozwillo-ozenergy-data

sed -i 's/localhost/ozwillo-datacore-1/g' /tmp/ozwillo-ozenergy/ozwillo-ozenergy-data/src/main/resources/oasis-datacore-ozenergy-data.properties

mvn clean install -DskipTests

# Clean up
apt-get purge -y git
apt autoremove -y
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
