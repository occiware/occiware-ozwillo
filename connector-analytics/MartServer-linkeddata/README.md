# How to build, run and dockerize

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

Now you can build this project :

```bash
mvn exec:java -Dexec.args=martserver.config
```
