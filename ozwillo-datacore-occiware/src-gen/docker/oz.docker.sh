#! /bin/sh
#
# Generated at Thu Jun 30 11:32:53 CEST 2016 from platform:/resource/ozwillo-datacore-occiware/oz.docker by org.occiware.clouddesigner.occi.docker.gen.conf
#

# Create the Docker Machine_VirtualBox named ozwillodatacoredev
docker-machine create --driver=virtualbox --virtualbox-disk-size 20000 ozwillodatacoredev

eval "$(docker-machine env ozwillodatacoredev)"

# Create the Docker Container named ozwillo-mongo-3
docker create --name ozwillo-mongo-3 mdutoo/ozwillo-mongo

# Start the Docker Container named ozwillo-mongo-3
docker start ozwillo-mongo-3

# Create the Docker Container named ozwillo-mongo-2
docker create --name ozwillo-mongo-2 mdutoo/ozwillo-mongo

# Start the Docker Container named ozwillo-mongo-2
docker start ozwillo-mongo-2

# Create the Docker Container named ozwillo-mongo-1
docker create --name ozwillo-mongo-1 mdutoo/ozwillo-mongo

# Start the Docker Container named ozwillo-mongo-1
docker start ozwillo-mongo-1


