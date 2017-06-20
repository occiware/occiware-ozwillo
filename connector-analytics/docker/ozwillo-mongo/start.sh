#!/bin/sh

# No --auth, though --reset could be useful here.
/usr/bin/mongod --smallfiles --noprealloc --replSet rs0 --logpath /var/log/mongodb/mongod.log --dbpath /data/db
