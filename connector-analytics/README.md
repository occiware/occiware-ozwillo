# OCCIware demo - Linked Data server on Docker optimized for analytics

This demo showcases OCCIware Studio deploying a complete, working Ozwillo Datacore cluster (one Java and 3 mongo replica nodes) on Docker both locally and on a remote Open Stack VM, and developing a custom OCCI extension (including designer and connector) for Linked Data that allows to publish data projects and let them use a specific mongo secondary rather than the whole cluster (typically for read-heavy queries such as for analytics). This last point is achieved by visually linking OCCI Resources across Cloud layers : from Linked Data as a Service (LDaaS) to Infrastructure as a Service (IaaS).

It has been originally shown at EclipseCon France 2016 on June the 9th (with versions 1.0 of Docker images and 2cada878ecaf901fb7750d65b6cda66815467ff2 of Datacore) in the [One Cloud API to rule them all](http://fr.slideshare.net/mdutoo/eclipsecon-2016-occiware-a-cloud-api-to-rule-them-all) talk.

In Fall 2016, it has been updated, improved and enriched, notably with demonstration of the connector's OCCI HTTP API, being provided by the erocci runtime through erocci-dbus-java and managed by the OCCInterface web admin UI.

## Prerequisites :

Java 8, Maven 3, OCCIware Studio (20160609 source), VirtualBox (5.0 ?), Docker 1.8.3 (workarounds must be applied with later versions), and the ozwillo-datacore-occiware_safe_20160630.tar.gz demo archive.

Also open the [EclipseCon slides](http://fr.slideshare.net/mdutoo/eclipsecon-2016-occiware-a-cloud-api-to-rule-them-all) to get screenshots of all steps (starting from slide n°39).

Note that there is no Ozwillo Datacore-specific software to install and deploy because it is all packaged within public Docker images.

### In finer details :

Install Docker & Docker Machine :

Follow the recommended steps in the [Docker Documentation - Installation for Ubuntu](https://docs.docker.com/engine/installation/linux/ubuntu/).

Downgrade to the right version of virtualbox :

``` bash
sudo apt-get remove virtualbox
wget http://download.virtualbox.org/virtualbox/5.0.18/virtualbox-5.0_5.0.18-106667~Ubuntu~trusty_amd64.deb
sudo dpkg -i Binaires\ VirtualBox/Ubuntu\ 14.04/virtualbox-5.0_5.0.18-106667-Ubuntu-trusty_amd64.deb
```

Download the right version of OCCIware Studio (the checkout to the commit shouldn't be needed : it is just in case harmful modifications would have been made to the Occi-Studio) :

``` bash
git clone git@github.com:occiware/ecore.git
cd ecore/clouddesigner
git checkout 710d0b33fd0a93d2d976c041272f11a54ee22b1c
```

Add in it the demo's Linked Data connector projects :

``` bash
cp -rf ../../occiware-ozwillo/connector-analytics/org.occiware.clouddesigner.occi.linkeddata* .
```

(this is because they have also been contributed to the Studio source, otherwise they can be imported right away in a downloaded [OCCIware Studio nightly build](http://www.obeo.fr/download/occiware/) and have not to have been mavenized like those)

Clone and build locally the Datacore, so that the connector will be able to find the Datacore client in the local maven repository :

``` bash
git clone git@github.com:ozwillo/ozwillo-datacore.git
cd ../../ozwillo-datacore
mvn clean install
```

You can now either 1. Build your own (simpler, but takes 40 minutes) and run it :

``` bash
cd ../ecore/clouddesigner/*parent
mvn clean install
cd ../org.occiware.clouddesigner.product/target/products
unzip org.occiware.clouddesigner.product-linux.gtk.x86_64.zip
./eclipse
```

Or 2. run it from source :

- download [Eclipse Neon](https://projects.eclipse.org/releases/neon), run it,
- add all Eclipse dependencies (EMF SDK & Compare, Acceleo Core SDK, OCL Examples and Editors SDK, Sirius Specifier Environment ; XText & Mylyn WikiText are now auto bundled) as [stated in the doc](http://occiware.github.io/content/developer-guides/snapshot/studio-setting-up-the-environment.html),
- import all ecore/clouddesigner projects,
- do mvn clean install in all the .connector.dependencies projects (such as org.occiware.clouddesigner.occi.linkeddata) in order to download all connector dependencies, then refresh the connector project. Its lib/ directory should now be filled with dependency jars.
- if there are M2E "Plugin execution not covered by lifecycle configuration" errors on tycho, select them all, right-click on them, choose Quick fix and Discover new M2E plugins
- and finally run the Linked Data Designer (Run as > Eclipse Application).

### Other tips :
BEWARE docker-machine doesn't allow hyphens in its VM names (better in v2)


## To make the sample OCCI configurations work, on a local VirtualBox (using Boot2Docker) :

1. In the Linked Data Designer, import the ozwillo-datacore-occiware project, which is in the connector-analytics subfolder of the occiware-ozwillo project. In the file tree on the left, find the representations.aird file, click on the '>' on its left in order to see its sub-elements (OCCI extensions) in the file tree, then again to see OCCI diagram kinds, and again to see OCCI configurations. Then open the following OCCI configurations by double-clicking on them :

	- ozwillo-datacore-cluster.docker : this will display the Docker designer,
	- Mytest.linkeddata using : this will display the Linked Data designer.

2. Before going any further, open the Properties panel by clicking on Window > Show view > Properties. When you explore the graphs, it will allow you to know what is inside the boxes, their configuration, and to edit it.

3. In the Docker Studio on said VM (ozwillodatacoredevlocal in the ozwillo-datacore-cluster.docker configuration), do the VM's "Start" action. Wait until VM has been created and Docker images downloaded.

4. Open a terminal and type the following command to enter the ozwillodatacoredevlocal VM :
``` bash
docker-machine ssh ozwillodatacoredevlocal
```
Inside the ozwillodatacoredevlocal VM, execute (don't forget to again replace mdutoo by your own login) :
``` bash
docker pull mdutoo/ozwillo-datacore:1.0
docker pull mdutoo/ozwillo-mongo:1.0
```
5. Start each container manually from the Docker-Studio starting from the mongo ones (docker start ozwillo-mongo-1/2/3).

6. If there is a "can't find image" error, first remove the ":1.0" suffix of all "image" attribute of Docker containers in the diagram (may come from a new version of the Docker API used by the Docker connector).

7. Initiate the mongo replica set with ozwillo-mongo-1 as primary :
(LATER or on Docker 1.8 their hostnames should have been set and it should be possible to use them rather than IPs)
(LATER this init should be doable by an OCCI Component at Platform level ex. MongoDatabase configuring a PaaS ex. Roboconf).
Inside the ozwillodatacoredevlocal VM, execute :
``` bash
docker exec -it ozwillo-mongo-1 mongo
use admin
rs.initiate()
// using IP since studio can not --add-host in both ways using links
//rs.add("172.17.0.2:27017") // NO it should be itself (check in /etc/hosts) and would raise error 13433 exception: can not find self in new replset config
rs.add("172.17.0.3:27017")
rs.add("172.17.0.4:27017")
cfg = rs.conf()
// one host is wrong, depending on the order of container creation :
// error 13433 exception: can not find self in new replset config
// => replace the docker-gen of this host by ip https://sebastianvoss.com/docker-mongodb-sharded-cluster.html
cfg.members[0].host = "172.17.0.2:27017"
// preventing ozwillo-mongo-2 from becoming master :
// (so that it can be targeted as custom secondary by an LDDatabaseLink without risk)
// https://docs.mongodb.com/v2.6/tutorial/configure-secondary-only-replica-set-member/
cfg.members[1].priority = 0
rs.reconfig(cfg)
rs.status()
// wait until rs.status() says all other replica are SECONDARY
```
8. Start (or restart) ozwillo-datacore-1 container the same way.
WORKAROUND for Boot2Docker > 1.8 ex. 1.11 :
then (quickly? can be done at any time later on) add the ozwillo-mongo-2 host definition by executing :
``` bash
docker exec -it ozwillo-datacore-1 /bin/bash
echo 172.17.0.3 ozwillo-mongo-2 >> /etc/hosts
```
Then wait until it's started (docker exec -it ozwillo-mongo-1 tail -f datacore.log)

9. Start virtualbox GUI and setup redirection of port 8080
LATER it would be better to be able to do it using the OCCI configuration of the VM, see #132.

10. In your browser, go to the Datacore Playground at http://localhost:8080/dc-ui/index.html (BEWARE http://localhost:8080/ may be broken) . The top right dropdown box should list all existing data projects. If you select for instance the "geo_1" project, its "project portal" should be displayed in the central color textarea, and clicking on its first (eponymous) link should display the project's configuration in JSON(-LD) format.

11. In the Linked Data Studio, do the "Publish" action on the "geo_1" project. It should set its "dcmp:frozenModelNames" property to ["*"] (and similarly "Unpublish" should set it to []), which can be seen in the Datacore Playground in said project's configuration.

12. In the Linked Data Studio, do the "Update" action on the "org_1" and "geo_analytics_1" projects. It should create them, meaning they should be listed in the Datacore Playground's project dropdown list after refreshing the page. Their project configuration (if displayed in the Datacore Playground as said) should be the same as the one set in the OCCI configuration. Especially, the org_1's project "dcmpv:name" property should be set to the value of the "occi.ld.project.name" attribute ("org_1"), and its "dcmp:localVisibleProjects" property should be a list of URIs of projects linked by LDProjectLinks in the OCCI configuration.
(For now the Update action is merely doing a "get" then "create" or "merge and update" according to whether the LDProject already exists. LATER the Update action could probably replaced by properly implementing the CRUD > POST action, possibly improved by implementing a "Synchronize" action getting back the current state of the configuration, maybe automatically executed, with "occi.ld.project.version" being -1 for not yet created projects)

13. In the Datacore Playground, select the "geo_analytics_1" project as current project in the top dropdown box. Then write the sample analytics query (*) in the Playground's URL bar and execute it using the "?" debug button. If you get a mongo timeout exception, re-execute the commands (inside the vm, of course : your aim is to access the datacore docker container and associate the mongo docker IP adress with the hostname) in part 8. Look up "serverAddress" in the results : its "host" should be set to the host of the Compute is linked to the OCCI LDProject through an LDDatabaseLink if any (the ozwillo-mongo-2 secondary MongoDB host in the demo configuration), and to the primary MongoDB host otherwise (ozwillo-mongo-1 in the demo configuration), as is the case when selecting another project (such as "geo_1").

(*) sample analytics query :

FOR NOW: "/dc/type/dcmo:model_0?dcmo:isHistorizable=false"

LATER: energy consumption-specific model and sample data will be provided and will allow for a more meaningful analytics query from a business point of view.


## Do the same with the OW2 Open Stack VM :
In the Docker Studio on said VM (ozwillodatacoredevlocal in the ozwillo-datacore-cluster.docker configuration), first set its "username" and "password" attributes (if you don't have any, you must ask 0W2 at https://jira.ow2.org/browse/SERVICEDESK ).

Then do as detailed for the VirtualBox VM.


## To rewrite the extension from scratch :
If you prefer rewriting the Linked Data extension from scratch rather than using the complete version provided by the demo archive, do as in the EclipseCon slides, with the following hints.

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
- a copy of the Docker Designer`s container Container
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

# first build ozwillo datacore :
``` bash
pushd YOUR_OZWILLO_DATACORE_WORKSPACE
git clone git@github.com:ozwillo/ozwillo-datacore.git
cd ozwillo-datacore
git checkout 2cada878ecaf901fb7750d65b6cda66815467ff2
mvn clean install -DskipTests
popd
```

# Log in to Docker

Create an account on the [Docker Cloud](https://cloud.docker.com/). And then log in.

``` bash
sudo docker login
```
# Build & push the docker images

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


## 20161007 suppl - expose (Linked Data) connector as an OCCI HTTP API :
(using [erocci](https://github.com/erocci/erocci/), and test it using OCCInterface)

# Build and start erocci-dbus-java-linkeddata :
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

# Clone and build [erocci](https://github.com/erocci/erocci/) :
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

# Clone, build and start OCCInterface (generic OCCI playground) :
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

# Test the Linked Data & Docker OCCI HTTP API using OCCInterface :
Click on the GET button to display the definition of all available OCCI extensions.

Click on the top dropdown (Kinds) : it should display all of its available OCCI extensions, and below their kinds. Clicking on each of them should list their instanciated OCCI resources. For instance, click on :
- linkeddata > LDProject to list all data projects, then click on a project that has been configured using the Linked Data Studio ("energy_xx" projects) to see its configuration. Then click on Edit then Post to change its configuration, just as it would be done using the Linked Data Studio, and just the same, changes can be seen in the Ozwillo Datacore playground at http://localhost:8080/dc-ui/index.html (BEWARE http://localhost:8080 may be broken).
- docker > ? to list all ? ; NOT WORKING YET see occiware/ecore#173 Docker connector kills erocci because has boolean attributes
