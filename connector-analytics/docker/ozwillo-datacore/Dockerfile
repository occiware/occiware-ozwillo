FROM tomcat:7-jre8

MAINTAINER Marc Dutoo, marc.dutoo@smile.fr


RUN apt-get update \
   && apt-get install -y --no-install-recommends vim \
   && rm -rf /var/lib/apt/lists/*

COPY start.sh /usr/local/tomcat/start.sh
COPY datacore /usr/local/tomcat/webapps/ROOT
COPY oasis-datacore-deploy-context.xml /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/oasis-datacore-deploy-context.xml
COPY oasis-datacore-deploy.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/oasis-datacore-deploy.properties

EXPOSE 8080

CMD /bin/sh start.sh && catalina.sh run
