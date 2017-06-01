# Use an official openjdk base image
FROM openjdk:8

# Maintainer info
MAINTAINER Marc Dutoo, marc.dutoo@smile.fr

# Set the working directory to /app
WORKDIR /app

# Copy the application and its configuration files
COPY logs /app/logs
COPY target /app/target
COPY pom.xml /app/pom.xml
COPY martserver.config /app/martserver.config

# Copy and execute the deployment script
ADD deploy.sh /tmp/deploy.sh
RUN /bin/bash -C /tmp/deploy.sh && rm /tmp/deploy.sh

# Make ports 8081 (http) and 8181 (https) available to the world outside this container
EXPOSE 8081
EXPOSE 8181

# Copy and set the start script for when the container launches
COPY start.sh /app/start.sh
CMD /bin/bash start.sh
