#!/bin/sh

# Workaround for Docker Studio since it doesn't support the --add-host parameter yet :
# Add other containers IP to /etc/hosts file
echo 172.17.0.2 ozwillo-mongo-1 >> /etc/hosts
echo 172.17.0.3 ozwillo-mongo-2 >> /etc/hosts
echo 172.17.0.4 ozwillo-mongo-3 >> /etc/hosts

# Launch Mongo Daemon : No --auth, though --reset could be useful here.
/usr/bin/mongod --smallfiles --fork --noprealloc --replSet rs0 --logpath /var/log/mongodb/mongod.log --dbpath /data/db

mongo < /root/master_deploy.js

# Check if the datacore db has already been restored : if not, restore it
DBNAME=datacore
if [ ! -e "/data/db/$DBNAME.ns" ]; then
    # Get the dump
    cd /tmp
    git clone https://github.com/occiware/occiware-ozwillo.git

    # Restore the mongo dump
    cd /tmp/occiware-ozwillo/mongo-dumps/
    tar xzf energy_fixed.tar.gz
    mongorestore --db datacore energy_fixed/dump/datacore/

    # Empty tmp directory
    rm -rf /tmp/*
fi

while :; do sleep 100; done
