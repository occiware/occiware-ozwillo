# Use an official tomcat base image
FROM tomcat:7-jre8

# Maintainer info
MAINTAINER Marc Dutoo, marc.dutoo@smile.fr

# Set the working directory to /app
WORKDIR /app

# Copy and execute the deployment script
ADD deploy.sh /tmp/deploy.sh
RUN /bin/bash -C /tmp/deploy.sh

# Make port 8088 (http) available to the world outside this container
EXPOSE 8088

# Copy and set the start script for when the container launches
COPY start.sh /app/start.sh
CMD ["/bin/bash", "start.sh"]
