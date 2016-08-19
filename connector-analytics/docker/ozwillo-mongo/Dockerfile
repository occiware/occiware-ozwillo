FROM debian:jessie

MAINTAINER Marc Dutoo, marc.dutoo@smile.fr

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10

RUN echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list

#ENV MONGO_VERSION 2.6.12
ENV MONGO_VERSION 2.6.5

RUN apt-get update \
   && apt-get install -y --no-install-recommends adduser mongodb-org-server=$MONGO_VERSION mongodb-org-shell=$MONGO_VERSION \
   && rm -rf /var/lib/apt/lists/*

# KO
#COPY mongod.conf /etc

# mongo default (NOT /var/lib/mongodb), else --dbpath 
RUN mkdir -p /data/db

# no --auth, though --reset could be
# rather CMD to allow to test overriding everything
#ENTRYPOINT
CMD ["/usr/bin/mongod", "--smallfiles", "--noprealloc", "--replSet", "rs0",\
   "--logpath", "/var/log/mongodb/mongod.log", "--dbpath", "/data/db"]

EXPOSE 27017 28017

