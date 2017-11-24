# Linked Data as a Service (LDaaS) horizontal scalability on Roboconf / Scalair through OCCI

This Roboconf application deploys Linked Data as a Service (LDaaS) through OCCI on Scalair VMWare
and creates a new front Datacore webapp VM if the number of request per minute is outside
an OCCI-configured range.

More precisely, this Roboconf application :
- deploys [through OCCI (Platform) on Scalair VMWare](src/main/model/graph/VM_OCCI_Scalair)
- a Linked Data as a Service (LDaaS) solution : [one (single) MongoDB and a (first) front Datacore webapp](src/main/model/graph/VM_OCCI_Scalair/initial.instances)
- whose application monitoring is [configured](src/main/model/graph/Datacore/files/webapps/ROOT/WEB-INF/classes/oasis-datacore-deploy.properties) to trigger Roboconf events (by creating files on the FS)
- if the number of request per minute is outside an OCCI (Monitoring and SLA extensions)-configured range
- that is read from a MARTServer.
- Said Roboconf events are brought back to the DM where they trigger commands,
- which by default log to a file, but [can be configured]() to instantiate a new Datacore front VM
- (which could easily be instantiated [on CloudAutomation](src/main/model/graph/VM_OCCI_CA) instead of Scalair).


## demonstrating this horizontal scalability :

Build this Roboconf app :
````bash
mvn clean install
````
This creates a Roboconf application template named "ldaas-roboconf-1.0-SNAPSHOT.zip" in the target/ directory.

Deploy (or reuse) a [Roboconf DM 0.9.1](http://roboconf.net/en/user-guide/installing-roboconf.html)
with OCCI Platform support in a VMWare hypervisor, install along [RabbitMQ](http://roboconf.net/en/user-guide/configuring-the-messaging.html)
and configure both together :
````bash
ssh ubuntu@ROBOCONFDM_IP
sudo su -
vi /etc/roboconf-dm/net.roboconf.messaging.rabbitmq.cfg
ROBOCONFDM_IP
sudo /etc/init.d/roboconf-dm stop
ps aux | grep java
sudo /etc/init.d/roboconf-dm start
````
then browse to its admin UI : http://ROBOCONFDM_IP:8181/roboconf-web-administration/index.html

there upload app template, then create app, deploy instance, deploy components, start them.

Get ready to see Roboconf scalability events in the LDaaS VM instance :
````bash
ssh ubuntu@INSTANCE_IP
tail -f /var/log/roboconf-agent/roboconf.log&
tail -f /var/lib/tomcat7/logs/catalina.out&
````

Simulate load : go to the Datacore REST Playground at http://INSTANCE_IP:8080/dc-ui/index.html
and hit the GET button a few times.

Once per minute, the [Datacore MeanRequestThresholdAlertFileReporter retrieves](https://github.com/ozwillo/ozwillo-datacore/blob/master/ozwillo-datacore-rest-server/src/main/java/org/oasis/datacore/server/metrics/cxf/MeanRequestThresholdAlertFileReporter.java#L292)
the threshold range configured in the OCCI MARTServer (if any) and compares the current
1-minute mean request number to it. If it's above, it creates a "/tmp/vmfile" on the
filesystem ; if it's below, a "/tmp/vmfilemin". Both files are monitored by the Roboconf
agent, which will be seen in the above tailed logs :
````
24-11-2017 10:37:18 MeanRequestThresholdAlertFileReporter [WARN] [min=0,000000, max=2,000000, current=21,995905]: creating max alert file /tmp/vmfile
2017-11-24 10:37:20,947 | DEBUG | MonitoringRunnable               | Monitoring Task is being invoked.
2017-11-24 10:37:20,947 | DEBUG | MonitoringRunnable               | A file with measure rules was found for instance 'Mongo on Scalair'.
2017-11-24 10:37:20,948 | DEBUG | ReconfigurableClientAgent        | Agent '/Mongo on Scalair' is sending a MsgNotifAutonomic message to the DM.
2017-11-24 10:37:20,948 | DEBUG | RabbitMqClient                   | A message is about to be published to default.roboconf.dm with routing key = ldaas-roboconf-1
````
and which will trigger the corresponding event and send it to the Roboconf DM,
which will act on it :
````bash
tail -f /var/log/roboconf-dm/roboconf.log&
2017-11-24 10:22:17,299 | DEBUG | RoboconfConsumer                 | [ default ] DM received a message MsgNotifAutonomic on routing key 'ldaas-roboconf-1'.
2017-11-24 10:22:17,300 | DEBUG | AutonomicMngrImpl                | Autonomic event 'autonomicFileDetected' is about to be recorded.
2017-11-24 10:22:17,300 | DEBUG | AutonomicApplicationContext      | Looking for rules to execute after an event was recorded for application ldaas-roboconf-1
2017-11-24 10:22:17,300 | DEBUG | AutonomicApplicationContext      | Rule autonomicFileDetected was found following the occurrence of the autonomicFileDetected event.
2017-11-24 10:22:17,300 | DEBUG | AutonomicMngrImpl                | Applying rule 'autonomicFileDetected' for event 'autonomicFileDetected'.
````


## FAQ

- OCCI Platform can't instanciate more than one VM of each template (Bug, being patched). Workaround : create Mongo and Datacore components in the same first instance or / and instantiate another VM template.
- the mean request number drops but still stays high minutes after a burst of requests. Workaround : configure Roboconf to wait some time before replicating the front VM again.
- how to debug VM creation : look for "occi" or "kind" to find OCCI requests in said Roboconf DM logs


------

OLD README.autonomic :

How it works
============

Deploy an instance of VM_OCCI_Scalair. When the instance is DEPLOYED_STARTED, put a file called "vmfile" in the /tmp directory of the VM (eg. "touch /tmp/vmfile" when logged on the VM, or transfer it using scp).

After a few seconds, the file will be deleted, an event called "autonomicFileDetected" will be sebt to the Roboconf DM, and logged on the DM side in /tmp/fileEvents.txt .

The same event will be triggered after deploying/starting an instance of Tomcat on the VM, if one puts a file called "tomcatfile" in /tmp on the VM.

Configuration details
=====================

In src/main/model directory:

Probes (probes/ directory)
--------------------------

A probe detects that a condition is met (eg. a threshold crossing) and trigger an event. It runs on the Roboconf AGENT side.

A probe file has the following syntax:
[EVENT <roboconf-handler-name> <event-name>]
<roboconf-handler-configuration>

A probe's file name is the name of the Roboconf component it applies to, followed by the ".measures" extension.
The probe is active when an instance of the component is alive (DEPLOYED_STARTED state).

Here, Tomcat.measures applies to any live instance of "Tomcat" component, and "VM_OCCI_Scalair.measures" applies to any live Scalair VM instance deployed with OCCI.
What is detected is the presence of a file in /tmp (respectively called "vmfile" for VM_OCCI_Scalair and "tomcatfile" for Tomcat).
When the file is present, an event called "autonomicFileDetected" is triggered, and the file is deleted.

Autonomic rules (rules.autonomic/ directory)
--------------------------------------------

A rule is associated to an event (triggered by a probe) and executed when the event is caught. It runs on the Roboconf DEPLOYMENT MANAGER (DM) side.

A rule's file name must have the ".drl" extension, and the file name must match the rule name inside (like for java classes).

Here, autonomicFileDetected.drl defines a rule named "autonomicFileDetected", that launches a command called "logFileEvent" when an "autonomicFileDetected" event occurs. The "logFileEvent" command logs the event in a file.

Commands (commands/ directory)
------------------------------

A command is executed by a rule.

A command file name is the command name itself, followed by the ".commands" extension: it is a roboconf command script.

Here, the "logFileEvent.commands" file defines a command named "logFileEvent", a script that appends a line in the "/tmp/fileEvents.txt" log file.

