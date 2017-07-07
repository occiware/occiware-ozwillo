#!/bin/sh

# Install necessary packages
apt-get update
apt-get install -y build-essential libssl-dev curl
rm -rf /var/lib/apt/lists/*

# Get sources and build
git clone https://github.com/Xia0ben/OCCInterface.git
mv OCCInterface/{,.[!.],..?}* .
npm install
