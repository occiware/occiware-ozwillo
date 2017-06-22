#!/bin/sh

# Workaround for Docker Studio since it doesn't support the --add-host parameter yet :
# Add other containers IP to /etc/hosts file
echo 172.17.0.2 ozwillo-mongo-1 >> /etc/hosts
echo 172.17.0.3 ozwillo-mongo-2 >> /etc/hosts
echo 172.17.0.4 ozwillo-mongo-3 >> /etc/hosts

# Launch Mongo Daemon : No --auth, though --reset could be useful here.
/usr/bin/mongod --smallfiles --noprealloc --replSet rs0 --logpath /var/log/mongodb/mongod.log --dbpath /data/db
