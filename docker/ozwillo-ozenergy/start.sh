#!/bin/sh

# Workaround for Docker Studio since it doesn't support the --add-host parameter yet :
# Add other containers IP to /etc/hosts file
echo 172.17.0.7 martserver-linkeddata-1 >> /etc/hosts
echo 172.17.0.5 ozwillo-datacore-1 >> /etc/hosts
echo 172.17.0.2 ozwillo-mongo-1 >> /etc/hosts
echo 172.17.0.3 ozwillo-mongo-2 >> /etc/hosts
echo 172.17.0.4 ozwillo-mongo-3 >> /etc/hosts

# Setup env variables
export SPARK_HOME=/root/spark-1.6.1-bin-hadoop2.6
export SPARK_MASTER_IP=localhost
export SPARK_MASTER_PORT=7077
export SPARK_MASTER_WEBUI_PORT=16160

export MAVEN_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n"
# export SPARK_SUBMIT_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=7500"

# Change OzEnergy config file
cd /app/ozwillo-ozenergy/oz-energy

/root/MartBTG/MartBTG.sh \
-t config/application.template.yml \
-r 'http://martserver-linkeddata-1:8081/?category=ldnode&attribute=occi.ld.node.name&value=energy' \
-c config/application.config \
-o config/application.yml

# Start mongod and OzEnergy
mongod --fork --logpath /app/mongod.log --smallfiles
cd /app/ozwillo-ozenergy/oz-energy
mvn spring-boot:run -DrunAggregation > /app/ozenergy.log
