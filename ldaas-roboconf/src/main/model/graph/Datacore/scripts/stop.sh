#!/bin/sh

export DEBIAN_FRONTEND=noninteractive

# Stop the Tomcat webserver
#pkill -9 -f tomcat
service tomcat stop
