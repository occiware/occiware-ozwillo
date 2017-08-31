#!/bin/sh

# Install necessary packages
apt-get update
apt-get install -y git curl default-jdk maven

## PostgreSQL installation
# Add the PostgreSQL PGP key to verify their Debian packages.
# It should be the same key as https://www.postgresql.org/media/keys/ACCC4CF8.asc
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
# Add PostgreSQL's repository. It contains the most recent stable release
#     of PostgreSQL, ``9.6``.
echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list
apt-get update
apt-get -y -q install software-properties-common
apt-get -y -q install postgresql-9.6 postgresql-client-9.6 postgresql-contrib-9.6
mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql

# Install Blynk
export BLYNK_SERVER_VERSION=0.26.3
mkdir /blynk
curl -L https://github.com/blynkkk/blynk-server/releases/download/v${BLYNK_SERVER_VERSION}/server-${BLYNK_SERVER_VERSION}.jar > /blynk/server.jar
mkdir /data
mkdir /config && touch /config/server.properties
echo enable.db=true >> /config/server.properties
echo enable.raw.db.data.store=true >> /config/server.properties

wget https://raw.githubusercontent.com/blynkkk/blynk-server/master/server/core/src/main/resources/create_schema.sql
mv create_schema.sql /tmp

su -s /bin/bash postgres
/usr/lib/postgresql/9.6/bin/postgres -D /var/lib/postgresql/9.6/main -c config_file=/etc/postgresql/9.6/main/postgresql.conf >/dev/null 2>&1 &
psql -U postgres -c '\i /tmp/create_schema.sql'
exit

# Build the the data project
cd /app
git clone https://github.com/ozwillo/ozwillo-ozenergy.git
cd /app/ozwillo-ozenergy/ozwillo-ozenergy-data

sed -i 's/localhost/ozwillo-datacore-1/g' /app/ozwillo-ozenergy/ozwillo-ozenergy-data/src/main/resources/oasis-datacore-ozenergy-data.properties

mvn clean install -DskipTests

# Clean up
apt-get purge -y git curl
apt autoremove -y
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
