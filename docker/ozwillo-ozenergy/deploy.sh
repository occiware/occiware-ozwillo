#!/bin/sh
echo "-----------------------------------------"
echo "# Install packages from ubuntu repositories"
echo "-----------------------------------------"
apt-get update
apt-get install -y apt-utils apt-transport-https wget git default-jre default-jdk maven mongodb
# The /data/db directory is required by mongodb to properly boot up
mkdir -p /data/db
echo "-----------------------------------------"
echo "# Install SBT"
echo "-----------------------------------------"
echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
apt-get update
apt-get install -y sbt

echo "-----------------------------------------"
echo "# Get the 1.24 version of the Ozwillo Java Spring Integration"
echo "-----------------------------------------"
cd /tmp
git clone https://github.com/ozwillo/ozwillo-java-spring-integration.git
cd /tmp/ozwillo-java-spring-integration
git checkout ozwillo-java-spring-integration-1.24
./gradlew install

echo "-----------------------------------------"
echo "# Get Spark"
echo "-----------------------------------------"
cd /root
wget --quiet https://d3kbcqa49mib13.cloudfront.net/spark-1.6.1-bin-hadoop2.6.tgz
tar -xzf spark-1.6.1-bin-hadoop2.6.tgz
rm spark-1.6.1-bin-hadoop2.6.tgz
echo "Done"

echo "-----------------------------------------"
echo "# Get and build OzEnergy sources"
echo "-----------------------------------------"
cd /app
git clone https://github.com/occiware/ozwillo-ozenergy.git
rm -rf /app/ozwillo-ozenergy/app-overview
rm -rf /app/ozwillo-ozenergy/ozwillo-ozenergy-data
cd /app/ozwillo-ozenergy/oz-energy-aggregations
sbt publish
cd /app/ozwillo-ozenergy/oz-energy
# Change OzEnergy config file
cp config/application.model.yml config/application.yml
sed -i 's/host:ozwillo-mongo-3/host:ozwillo-mongo-3/g' config/application.yml
sed -i 's/url\:\ https\:\/\/data.ozwillo-preprod.eu/\#url\:\ https\:\/\/data.ozwillo-preprod.eu/g' config/application.yml
sed -i 's/\#url\:\ http\:\/\/localhost\:8080/url\:\ http\:\/\/ozwillo-datacore-1\:8088/g' config/application.yml
mvn clean package -DskipTests

echo "-----------------------------------------"
echo "# Clean up"
echo "-----------------------------------------"
# Remove dependency sources
rm -rf /tmp/*
# Remove building dependencies
apt-get purge -y apt-utils apt-transport-https git
# Remove apt cache
rm -rf /var/lib/apt/lists/*
