# Use an official tomcat base image
FROM tomcat:7-jre8

# Maintainer info
MAINTAINER Marc Dutoo, marc.dutoo@smile.fr

# Copy and execute the deployment script
ADD deploy.sh /tmp/deploy.sh
RUN /bin/bash -C /tmp/deploy.sh

# Copy the configuration files
COPY oasis-datacore-deploy-context.xml /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/oasis-datacore-deploy-context.xml
COPY oasis-datacore-deploy.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/oasis-datacore-deploy.properties

# Make port 8088 (http) available to the world outside this container
EXPOSE 8088

# Copy and set the start script for when the container launches
COPY start.sh /usr/local/tomcat/start.sh
CMD /bin/bash start.sh
