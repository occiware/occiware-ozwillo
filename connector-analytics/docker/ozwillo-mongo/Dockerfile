# Use an official debian base image
FROM debian:jessie

# Maintainer info
MAINTAINER Marc Dutoo, marc.dutoo@smile.fr

# Set the working directory to /app
WORKDIR /app

# Copy and execute the deployment scripts
ADD deploy.sh /tmp/deploy.sh
ADD master_deploy.js /tmp/master_deploy.js
RUN /bin/bash -C /tmp/deploy.sh

# Default MongoDB port
EXPOSE 27017
# Default MongoDB HTTP API Endpoint port
EXPOSE 28017

# Copy and set the start script for when the container launches
COPY start.sh /app/start.sh
CMD /bin/bash start.sh
