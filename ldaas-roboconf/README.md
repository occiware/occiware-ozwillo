# Linked Data as a Service (LDaaS) horizontal scalability on Roboconf through OCCI



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

