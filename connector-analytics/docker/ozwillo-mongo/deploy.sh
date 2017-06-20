#!/bin/sh

# CONFIGURATION VARIABLES (you might need to change them !)
is_mongo_master=true

# Export necessary ENV variables
export MONGO_VERSION=2.6.5

# mongo default (NOT /var/lib/mongodb), else --dbpath
mkdir -p /data/db

# Install necessary packages
apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list
apt-get update
apt-get install -y --no-install-recommends adduser mongodb-org-server=$MONGO_VERSION mongodb-org-shell=$MONGO_VERSION
rm -rf /var/lib/apt/lists/*

# If this is the master mongo, start mongod to configure it

# ...do something interesting...
if [ "$the_world_is_flat" = true ] ; then
    echo 'Be careful not to fall off!'
fi
/usr/bin/mongod --smallfiles --noprealloc --replSet rs0 --logpath /var/log/mongodb/mongod.log --dbpath /data/db

mongo < /tmp/master_deploy.js
