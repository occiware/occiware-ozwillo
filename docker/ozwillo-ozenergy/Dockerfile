# Use an official openjdk base image
FROM ubuntu:xenial

# Maintainer info
MAINTAINER Marc Dutoo, marc.dutoo@smile.fr

# Set the working directory to /app
WORKDIR /app

# Copy and execute the deployment script
ADD deploy.sh /tmp/deploy.sh
RUN /bin/bash -C /tmp/deploy.sh

# Make port 8080 (http) available to the world outside this container, for app
EXPOSE 8080
# Make port 8000 (http) available to the world outside this container, for jdpa
# oz-energy debug
EXPOSE 8000

# Copy and set the start script for when the container launches
COPY start.sh /app/start.sh
CMD /bin/bash start.sh
