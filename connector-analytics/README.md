# OCCIware demo - Linked Data server on Docker optimized for analytics

## Introduction

This demo showcases OCCIware Studio deploying a complete, working Ozwillo Datacore cluster (one Java and 3 mongo replica nodes) on Docker both locally and on a remote Open Stack VM, and developing a custom OCCI extension (including designer and connector) for Linked Data that allows to publish data projects and let them use a specific mongo secondary rather than the whole cluster (typically for read-heavy queries such as for analytics). This last point is achieved by visually linking OCCI Resources across Cloud layers : from Linked Data as a Service (LDaaS) to Infrastructure as a Service (IaaS).

It has been originally shown at EclipseCon France 2016 on June the 9th (with versions 1.0 of Docker images and 2cada878ecaf901fb7750d65b6cda66815467ff2 of Datacore) in the [One Cloud API to rule them all](http://fr.slideshare.net/mdutoo/eclipsecon-2016-occiware-a-cloud-api-to-rule-them-all) talk.

In Fall 2016, it has been updated, improved and enriched, notably with demonstration of the connector's OCCI HTTP API, being provided by the erocci runtime through erocci-dbus-java and managed by the OCCInterface web admin UI.

## Requirements

Java 8, Maven 3, OCCIware Studio (latest in the ecore repository), VirtualBox (latest, tested with 5.0.40), Docker & Docker-Machine (latest, respectively tested with 17.03.1-ce and 0.4.1).

You might want to take a look at the latest presentation on Occiware made by Marc Dutoo : [Occiwareposs 2016 - An extensible standard xaas cloud consumer platform](https://fr.slideshare.net/mdutoo/occiwareposs-2016-an-extensible-standard-xaas-cloud-consumer-platform). In order to better understand the slides, you may want to watch the [video of the presentation on Youtube](https://www.youtube.com/watch?v=HuDEbpC0eSw).

### Installation of the requirements

Install Docker :

Follow the recommended steps in the [Docker Documentation - Installation for Ubuntu](https://docs.docker.com/engine/installation/linux/ubuntu/) page.

Install Docker Machine :

Follow the recommended steps in the [Install Docker Machine](https://docs.docker.com/machine/install-machine/) page.

Install Virtualbox, java and maven :

``` bash
sudo apt-get install virtualbox maven default-jre default-jdk
```

If you didn't already do it, install OCCI-Studio following the indications on the "If you want to play around with the sources" section of the [official documentation page](http://occiware.github.io/content/developer-guides/snapshot/studio-setting-up-the-environment.html). Ideally, follow the instructions of parts "1.1. The easy way : use the CloudDesigner / OCCI-Studio" and "2. The “guest” Eclipse : the OCCI-Studio Project".

Supposing you already cloned this repository **IN THE SAME DIRECTORY** as the ecore repository (if you didn't, please do, it will make following the next steps a breeze), go to the ecore/clouddesigner directory and execute the following command inside it to update the linkeddata packages of the ecore repository. This step shall be removed when the code will be integrated, but for now, it will do.

``` bash
cp -rf ../../occiware-ozwillo/connector-analytics/org.occiware.clouddesigner.occi.linkeddata* .
```

Go back to the directory where you have the ecore and occiware-ozwillo repositories, and clone + build locally the Datacore, so that the connector will be able to find the Datacore client in the local maven repository :

``` bash
git clone https://github.com/ozwillo/ozwillo-datacore.git
cd ozwillo-datacore
mvn clean install
```

Finally, in the "Host Eclipse", relaunch the CloudDesigner so that the modifications are applied. Alternatively, you can also go in the ecore/clouddesigner directory and build everything from scratch :

``` bash
cd ecore/clouddesigner
mvn clean verify
```

## Building and running the project

1. In the CloudDesigner (the "Guest Eclipse"), import the ozwillo-datacore-occiware project, which is in the connector-analytics subfolder of the occiware-ozwillo repository. In the file tree on the left, find the representations.aird file, click on the '>' on its left in order to see its sub-elements (OCCI extensions) in the file tree, then again to see OCCI diagram kinds, and again to see OCCI configurations. Then open the following OCCI configurations by double-clicking on them :

	- ozwillo-datacore-cluster.docker : this will display the Docker designer,
	- Mytest.linkeddata using : this will display the Linked Data designer.

2. Before going any further, open the Properties panel by clicking on Window > Show view > Properties. When you explore the graphs, it will allow you to know what is inside the boxes, their configuration, and to edit it.
> Important Performance Note : Since the **Properties panel** is being listened to by model elements through EMF, having it always open can lead to **tremendous lags** when using the Docker studio for example. As long as the performance issues are not solved, **we recommend that you open it only when you need to see the details of a particular element.**

3. In the Docker designer of ozwillo-datacore-cluster.docker, right-click on the ozwillodatacoredevlocal VM , and click on Cockeer Execute > Start (We don't use Startall since an unsolved bug prevents the studio from asking the docker instance inside the vm to pull the images by itself). Wait until VM has been created.

4. Open a terminal aside from the studio and type the following command to enter the ozwillodatacoredevlocal VM :
``` bash
docker-machine ssh ozwillodatacoredevlocal
```
Inside the ozwillodatacoredevlocal VM, execute (if you created your own images following the steps far below, don't forget to replace mdutoo by your own login) :
``` bash
docker pull mdutoo/ozwillo-datacore:1.0
docker pull mdutoo/ozwillo-mongo:1.0
```
5. Start each container manually from the Docker-Studio **starting from the mongo ones,in the order of their numbers** (docker start ozwillo-mongo-1/2/3, so that it doesn't mess with their IPs). If there is a "can't find image" error, first remove the ":1.0" suffix of all "image" attribute of Docker containers in the diagram (may come from a new version of the Docker API used by the Docker connector).

6. Initiate the mongo replica set with ozwillo-mongo-1 as primary :

	(LATER or on Docker 1.8 their hostnames should have been set and it should be possible to use them rather than IPs)

	(LATER this init should be doable by an OCCI Component at Platform level ex. MongoDatabase configuring a PaaS ex. Roboconf).

	Here, if you started the VM and containers in the right order, the VM itself has an IP of 172.17.0.1, the ozwillo-mongo-1 has 172.17.0.2, the ozwillo-mongo-2 has 172.17.0.3, the ozwillo-mongo-3 has 172.17.0.4, the ozwillo-datacore-1 has 172.17.0.5.

	Inside the ozwillodatacoredevlocal VM, execute (see step 4. if you forgot how to enter the VM):

	``` bash
	docker exec -it ozwillo-mongo-1 mongo
	use admin
	rs.initiate()
	# Using IP since studio can not yet --add-host in both ways using links
	# If ozwillo-mongo-1 has IP adress 172.17.0.2, if you did rs.add("172.17.0.2:27017"), it would raise error 13433 exception: can not find self in new replset config.
	rs.add("172.17.0.3:27017")
	rs.add("172.17.0.4:27017")
	cfg = rs.conf()
	# Replaces the docker-gen of this host by ip https://sebastianvoss.com/docker-mongodb-sharded-cluster.html
	cfg.members[0].host = "172.17.0.2:27017"
	# Prevents ozwillo-mongo-2 from becoming master :
	# (so that it can be targeted as custom secondary by an LDDatabaseLink without risk)
	# https://docs.mongodb.com/v2.6/tutorial/configure-secondary-only-replica-set-member/
	cfg.members[1].priority = 0
	rs.reconfig(cfg)
	rs.status()
	# check if rs.status() says all other replica are SECONDARY
	```
7. Start ozwillo-datacore-1 container through the studio (Right-click on its box > Docker Execute > Start). Then add the ozwillo-mongo-2 host definition by executing :
``` bash
docker exec -it ozwillo-datacore-1 /bin/bash
echo 172.17.0.3 ozwillo-mongo-2 >> /etc/hosts
```

8. Open the Virtualbox GUI and setup redirection of port 8080 : right-click on the VM > Configuration > Network > Advanced > Port Redirection > Click the Add button (right of the window) > and fill in the info (Name : whatever you want, Protocol : TCP, Host IP : 127.0.0.1, Host Port : 8080, Guest IP : let it empty, Guest Port : 8080) > OK > OK > Close Virtualbox window.

	(LATER it would be better to be able to do it using the OCCI configuration of the VM, see [issue #132 on Github](https://github.com/occiware/ecore/issues/132)).

9. **Testing 1 :** In your browser, go to the Datacore Playground at http://localhost:8080/dc-ui/index.html (http://localhost:8080/ may not redirect you properly). You can access the Playground itself by clicking on the link on top, or directly going to http://localhost:8080/dc-ui/ The top right dropdown box should list all existing data projects. If you select for instance the "geo_1" project, its "project portal" should be displayed in the central colored textarea, and clicking on its first (eponymous) link should display the project's configuration in JSON(-LD) format.

10. **Testing 2 :** In the Linked Data Studio, do the "Publish" action on the "geo_1" project (Right-Click on its box > Publish), in the Mytest file. It should set its "dcmp:frozenModelNames" property to ["\*"] (and similarly "Unpublish" should set it to []), which can be seen in the Datacore Playground in said project's configuration.

11. **Testing 3 :** In the Linked Data Studio, do the "Update" action on the "org_1" and "geo_analytics_1" projects. It should create them, meaning they should be listed in the Datacore Playground's project dropdown list after refreshing the page. Their project configuration (if displayed in the Datacore Playground as said) should be the same as the one set in the OCCI configuration. Especially, the org_1's project "dcmpv:name" property should be set to the value of the "occi.ld.project.name" attribute ("org_1"), and its "dcmp:localVisibleProjects" property should be a list of URIs of projects linked by LDProjectLinks in the OCCI configuration.

	*Note* : For now the Update action is merely doing a "get" then "create" or "merge and update" according to whether the LDProject already exists. LATER, the Update action could probably replaced by properly implementing the CRUD > POST action, possibly improved by implementing a "Synchronize" action getting back the current state of the configuration, maybe automatically executed, with "occi.ld.project.version" being -1 for not yet created projects.

12. **Testing 4 :** In the Datacore Playground, select the "geo_analytics_1" project as current project in the top dropdown box. Then copy-paste the sample analytics query below (\*) in the Playground's URL bar and execute it using the "?" debug button (if you get a mongo timeout exception, re-execute the commands of part 8. inside the VM). Find "serverAddress" (use Ctrl+F in your browser, that will be faster) in the results : its "host" attribute should be set to the host of the Compute that is linked to the OCCI LDProject through a LDDatabaseLink (the ozwillo-mongo-2 secondary MongoDB host in the demo configuration), and to the primary MongoDB host otherwise (ozwillo-mongo-1 in the demo configuration), as is the case when selecting another project (such as "geo_1").

(\*) sample analytics query FOR NOW :

    /dc/type/dcmo:model_0?dcmo:isHistorizable=false

LATER: energy consumption-specific model and sample data will be provided and will allow for a more meaningful analytics query from a business point of view.

## If you want to use the OW2 Open Stack VM :

In the Docker Studio on said VM (ozwillodatacoredevlocal in the ozwillo-datacore-cluster.docker configuration), first set its "username" and "password" attributes (if you don't have any, you must ask 0W2 at https://jira.ow2.org/browse/SERVICEDESK ).

Then do as detailed for the local VirtualBox VM.

## To rewrite the extension from scratch :

If you prefer rewriting the Linked Data extension from scratch rather than using the complete version provided by the demo archive, do as in the EclipseCon slides, with the following hints.

### Important tip :
BEWARE docker-machine doesn't allow hyphens in its VM names (better in v2).

### Extension definition linkeddata.occie :
reuse the provided one, or define it using the Extension designer like this :
```
extension linkeddata : "http://occiware.org/linkeddata#"
import "http://schemas.ogf.org/occi/core#/"
import "http://schemas.ogf.org/occi/infrastructure#/"
import "http://schemas.ogf.org/occi/platform#/"
kind ldproject extends core.resource {
	title "LDProject"
	attribute occi.ld.project.name : core.String
	attribute occi.ld.project.published : core.Boolean = "false"
	attribute occi.ld.project.robust : core.Boolean = "true"
	action publish ()
	action unpublish ()
	action update ()
}
kind lddatabaselink extends core.link {
	title "LDDatabaseLink"
	attribute occi.ld.dblink.database : core.String = "datacore"
	attribute occi.ld.dblink.port : core.Number = "27017"
}
kind ldprojectlink extends core.link {
}
```

### Extension connector :
reuse the provided code.

### Extension designer :
reuse the provided one, or use the generated one and add
- a copy of the Docker Designer's container Container
- and a Drop Container that targets it, to allow drag'n'dropping Docker containers in the LinkedData Designer

### Docker configuration occiware-datacore-cluster.docker/occic :
reuse the provided one, or define it using the Docker designer like this :
(only showing the local VirtualBox, but others ex. remote OW2 OpenStack can be created just the same way)
```
configuration
use "http://occiware.org/occi/docker#/"
resource "6df690d2-3158-40c4-88fb-d1c41584d6e4" : docker.machine_VirtualBox {
	state name = "ozwillodatacoredev"
	state occi.core.id = "6df690d2-3158-40c4-88fb-d1c41584d6e4"
	link "da58c05f-fe96-4fc8-aab9-3e9232aab767" : docker.contains target
	"9dcd39ac-4451-44eb-ac05-227951c23d40" {
		state occi.core.id = "da58c05f-fe96-4fc8-aab9-3e9232aab767"
	}
	link "a92ea98c-ca50-467b-a97c-bba9cc483322" : docker.contains target
	"71405ae7-2402-455c-9c96-0de3e4fc39a6" {
		state occi.core.id = "a92ea98c-ca50-467b-a97c-bba9cc483322"
	}
	link "177a2374-1194-41b0-9f34-0c873b3400bf" : docker.contains target
	"55936644-6215-495d-967f-7d453be484a5" {
		state occi.core.id = "177a2374-1194-41b0-9f34-0c873b3400bf"
	}
	link "fe219da5-79d0-477b-ae3d-f3c976c70d6a" : docker.contains target
	"cc806100-d62a-488f-ac13-eb9b20d2914e" {
		state occi.core.id = "fe219da5-79d0-477b-ae3d-f3c976c70d6a"
	}
}
resource "9dcd39ac-4451-44eb-ac05-227951c23d40" : docker.container {
	state occi.core.id = "9dcd39ac-4451-44eb-ac05-227951c23d40"
	state name = "ozwillo-mongo-1"
	state image = "mdutoo/ozwillo-mongo"
	state occi.compute.hostname = "ozwillo-mongo-1"
}
resource "71405ae7-2402-455c-9c96-0de3e4fc39a6" : docker.container {
	state occi.core.id = "71405ae7-2402-455c-9c96-0de3e4fc39a6"
	state name = "ozwillo-mongo-2"
	state image = "mdutoo/ozwillo-mongo"
	state occi.compute.hostname = "ozwillo-mongo-2"
}
resource "55936644-6215-495d-967f-7d453be484a5" : docker.container {
	state occi.core.id = "55936644-6215-495d-967f-7d453be484a5"
	state name = "ozwillo-mongo-3"
	state image = "mdutoo/ozwillo-mongo"
	state occi.compute.hostname = "ozwillo-mongo-3"
}
resource "cc806100-d62a-488f-ac13-eb9b20d2914e" : docker.container {
	state occi.core.id = "cc806100-d62a-488f-ac13-eb9b20d2914e"
	state name = "ozwillo-datacore-1"
	state image = "mdutoo/ozwillo-datacore:latest"
	state ports = "8080:8080"
	state occi.compute.hostname = "ozwillo-datacore-1"
	link "bf49c770-453c-4a16-a7f0-4f8bae191706" : docker.link target
	"9dcd39ac-4451-44eb-ac05-227951c23d40" {
		state occi.core.id = "bf49c770-453c-4a16-a7f0-4f8bae191706"
	}
	link "fe41e935-801c-41a4-8e2f-5b29daa978ce" : docker.link target
	"55936644-6215-495d-967f-7d453be484a5" {
		state occi.core.id = "fe41e935-801c-41a4-8e2f-5b29daa978ce"
	}
	link "29e9dbc4-44db-48b3-af1d-7d0123bcf3ec" : docker.link target
	"71405ae7-2402-455c-9c96-0de3e4fc39a6" {
		state occi.core.id = "29e9dbc4-44db-48b3-af1d-7d0123bcf3ec"
	}
}
```

### LinkedData configuration Mytest.linkeddata/occic :
reuse the provided one, or define it using the LinkedData designer like in the EclipseCon slides.

### To rebuild the docker images :

First build ozwillo datacore :
``` bash
pushd YOUR_OZWILLO_DATACORE_WORKSPACE
git clone git@github.com:ozwillo/ozwillo-datacore.git
cd ozwillo-datacore
git checkout 2cada878ecaf901fb7750d65b6cda66815467ff2
mvn clean install -DskipTests
popd
```

#### Log in to Docker

Create an account on the [Docker Cloud](https://cloud.docker.com/). And then log in.

``` bash
sudo docker login
```
#### Build & push the docker images

Rplace mdutoo by your dockerhub user name in the following command lines, also replace ImageID by the new id that you get from sudo docker images
``` bash
cd docker/ozwillo-datacore
cp -rf YOUR_OZWILLO_DATACORE_WORKSPACE/ozwillo-datacore/ozwillo-datacore-web/target/datacore .
sudo docker build -t mdutoo/ozwillo-datacore:1.0 .
sudo docker images
sudo docker tag <ImageID> mdutoo/ozwillo-datacore:1.0
sudo docker push mdutoo/ozwillo-datacore:1.0

cd docker/ozwillo-mongo
sudo docker build -t mdutoo/ozwillo-mongo:1.0 .
sudo docker images
sudo docker tag <ImageID> mdutoo/ozwillo-mongo:1.0
sudo docker push mdutoo/ozwillo-mongo:1.0
```


#### 20161007 suppl - expose (Linked Data) connector as an OCCI HTTP API :
(using [erocci](https://github.com/erocci/erocci/), and test it using OCCInterface)

#### Build and start erocci-dbus-java-linkeddata :
The [erocci-dbus-java-linkeddata project](https://github.com/occiware/occiware-ozwillo/blob/master/connector-analytics/erocci-dbus-java-linkeddata/pom.xml) is merely erocci-dbus-java with the Linked Data connector and its dependencies. The Linked Data connector is configured to manage an Ozwillo Datacore server that is deployed at http://localhost:8080 by default (where it should be available after the previous steps).

Beware, building it requires that the Linked Data connector has been built and installed in your local maven repository. So if you've not done it yet, first build the OCCIware Studio as explained previously.

``` bash
cd erocci-dbus-java-linkeddata
# install JNI deps :
mvn initialize
mvn clean install
# do : (JNI being OK)
mvn exec:java -Dexec.mainClass="org.ow2.erocci.backend.BackendDBusService"
```

#### Clone and build [erocci](https://github.com/erocci/erocci/) :
``` bash
git clone git@github.com:erocci/erocci.git
cd erocci
git checkout 9d1349049217482ecec0fec33f4ecff047dde07f
# else GET /-/ returns 404 with newer erocci deps
make FRONTEND=1

# Start erocci with DBus for OCCIware (on port 8081) :
./start.sh -c ../occiware-ozwillo/connector-analytics/erocci-dbus-java-linkeddata/sys.config
```

Then erocci should be available at http://localhost:8081, and its embedded OCCInterface UI at http://localhost:8081/_frontend .

## Clone, build and start OCCInterface (generic OCCI playground) :
If you want your own standalone OCCInterface, so that you can add custom examples for instance (or if erocci's embedded OCCInterface doesn't work), get it up and running this way.

First, if you don't have the right version of node and npm (6.2.0 works), an easy way to install both, whatever the version of node you already have, is to install [nvm](https://github.com/creationix/nvm) :
``` bash
sudo apt-get update
sudo apt-get install build-essential libssl-dev
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | bash
nvm install v6.2.0
```

Then build and run :

``` bash
git clone git@github.com:occiware/OCCInterface.git
cd OCCInterface
npm install
npm run dev
```

Now use your web browser to go to [http://localhost:3000/](http://localhost:3000/) where it has been made available. There write http://localhost:8081 as the OCCI server URL in the top input field and click on the Use button.

## Test the Linked Data & Docker OCCI HTTP API using OCCInterface :
Click on the GET button to display the definition of all available OCCI extensions.

Click on the top dropdown (Kinds) : it should display all of its available OCCI extensions, and below their kinds. Clicking on each of them should list their instanciated OCCI resources. For instance, click on :
- linkeddata > LDProject to list all data projects, then click on a project that has been configured using the Linked Data Studio ("energy_xx" projects) to see its configuration. Then click on Edit then Post to change its configuration, just as it would be done using the Linked Data Studio, and just the same, changes can be seen in the Ozwillo Datacore playground at http://localhost:8080/dc-ui/index.html (BEWARE http://localhost:8080 may be broken).
- docker > ? to list all ? ; NOT WORKING YET see occiware/ecore#173 Docker connector kills erocci because has boolean attributes
