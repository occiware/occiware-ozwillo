#!/bin/sh

# Export necessary ENV variables
export MONGO_VERSION=2.6.5

# mongo default (NOT /var/lib/mongodb), else --dbpath
mkdir -p /data/db

# Install necessary packages
apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list
apt-get update
apt-get install -y --no-install-recommends git ca-certificates adduser mongodb-org-server=$MONGO_VERSION mongodb-org-shell=$MONGO_VERSION mongodb-org-tools=$MONGO_VERSION
rm -rf /var/lib/apt/lists/*

# Empty tmp directory
rm -rf /tmp/*
