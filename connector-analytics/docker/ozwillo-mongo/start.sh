#!/bin/sh

# CONFIGURATION VARIABLES (you might need to change them !)
is_mongo_master=false

# Workaround for Docker Studio since it doesn't support the --add-host parameter yet :
# Add other containers IP to /etc/hosts file
echo 172.17.0.2 ozwillo-mongo-1 >> /etc/hosts
echo 172.17.0.3 ozwillo-mongo-2 >> /etc/hosts
echo 172.17.0.4 ozwillo-mongo-3 >> /etc/hosts

# No --auth, though --reset could be useful here.
/usr/bin/mongod --smallfiles --noprealloc --replSet rs0 --logpath /var/log/mongodb/mongod.log --dbpath /data/db

# If this is the master mongo, configure it
if [ "$is_mongo_master" = true ] ; then
    mongo < /tmp/master_deploy.js
fi
