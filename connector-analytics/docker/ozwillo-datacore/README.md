# Configuration for Deployment

## IP and Port

To change the port or IP adress of the datacore ,the tomcat server that serves it and Docker, respectively 
do :

- Change the following line in oasis-datacore-deploy.properties :
```yaml
datacoreApiServer.baseUrl=http://localhost:8088
```
- Change the following lines in deploy.sh :
```bash
# Change Tomcat's default port from 8080 to 8088
sed -i 's/8080/8088/g' /usr/local/tomcat/conf/server.xml
```
- Change the following lines in Dockerfile :
```bash
# Make port 8088 (http) available to the world outside this container
EXPOSE 8088
```

## Other

Please refer to oasis-datacore-deploy.properties and oasis-datacore-deploy-context.xml .
