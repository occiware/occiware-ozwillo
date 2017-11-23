#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

yes | apt-get remove --purge libapache2-mod-jk apache2

