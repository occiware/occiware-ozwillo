#!/bin/sh

export DEBIAN_FRONTEND=noninteractive

yes | apt-get remove --purge mongodb-org-server mongodb-org-shell
#rm -rf /data/db
