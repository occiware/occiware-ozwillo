FROM openjdk:8-jre
# on which is based tomcat:7-jre8

MAINTAINER Marc Dutoo, marc.dutoo@smile.fr

ENV APP_HOME /usr/local/app
RUN set -x && mkdir -p "$APP_HOME"
WORKDIR $APP_HOME

RUN apt-get update \
   && apt-get install -y --no-install-recommends vim \
   && rm -rf /var/lib/apt/lists/*

COPY oz-energy-0.0.1-SNAPSHOT.jar oz-energy-0.0.1-SNAPSHOT.jar
COPY application.yml application.yml
COPY start.sh start.sh
RUN set -x && chmod +x start.sh

EXPOSE 8080
# because otherwise can't log to preprod kernel

CMD ["sh", "start.sh"]
