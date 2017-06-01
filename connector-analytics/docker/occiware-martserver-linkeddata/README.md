## How to build and run it locally

If you haven't done it already, get the Martserver and build it with maven so that its jar ends up in the local maven repository.

```bash
git clone https://github.com/occiware/MartServer.git
cd MartServer
mvn initialize
mvn clean install
```

If you followed the README.md in the parent folder, you must have already built the org.occiware.clouddesigner.occi.linkeddata and org.occiware.clouddesigner.occi.linkeddata.connector projects. If not, go in their source folders (in the parent folder) and build them (the order is important!):

```bash
cd ../org.occiware.clouddesigner.occi.linkeddata
mvn clean install
cd ../org.occiware.clouddesigner.occi.linkeddata.connector
mvn clean install
```

```bash
git clone https://github.com/occiware/MartServer.git
cd MartServer
mvn initialize
mvn clean install
```

Build the project :

```bash
mvn clean install
```

Now you can run this project :

```bash
mvn exec:java -Dexec.args=martserver.config
```

If you want to build a jar with all the dependencies in order to dockerize do :

```bash
mvn clean compile assembly:single
```

To launch the jar, go to the target directory and execute it with java (with the config as first parameter) :

```bash
cd target/
java -jar mart-server-linkeddata-1.0-SNAPSHOT-jar-with-dependencies.jar ../martserver.config
```

To check if everything is working properly, execute the following request :

```bash
curl -v -X GET http://localhost:8081/.well-known/org/ogf/occi/-/ -H "accept: application/json"
```

## Creating a docker image

If you have Docker installed (if not, you can find how to do so [here](https://docs.docker.com/engine/installation/)), you may want to create a docker container.

Supposing you are currently in this README.md's directory, that is to say, "occiware-martserver-linkeddata", and that you have followed all the previous steps so that you built a jar with all the dependencies, do :

``` bash
sudo docker build -t mart-server-linkeddata .
sudo docker run -p 8081:8081 mart-server-linkeddata
```

To share the docker image (replace <YOURDOCKERUSERNAME>) :

``` bash
sudo docker build -t <YOURDOCKERUSERNAME>/mart-server-linkedata:1.0 .
sudo docker push <YOURDOCKERUSERNAME>/mart-server-linkedata:1.0 .
```
