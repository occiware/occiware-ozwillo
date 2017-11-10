#!/bin/bash

# Tomcat_size=2
# Tomcat_0_ip=127.0.0.1
# Tomcat_1_ip=127.0.0.2
# Tomcat_0_portAJP=8009
# Tomcat_1_portAJP=8010

workers_propfile=/etc/libapache2-mod-jk/workers.properties

wlist=loadbalancer
for (( c=0; c<$Tomcat_size; c++ ))
do
 wlist+=,worker$c
 if [ $c -eq 0 ]
 then
   balance_workers+=worker$c
 else
   balance_workers+=,worker$c
 fi
done

echo worker.list=$wlist > $workers_propfile
echo worker.loadbalancer.type=lb >> $workers_propfile
echo worker.loadbalancer.balance_workers=$balance_workers >> $workers_propfile

for (( c=0; c<$Tomcat_size; c++ ))
do
 echo worker.worker$c.type=ajp13 >> $workers_propfile
 vname=Tomcat_${c}_ip
 eval "echo worker.worker$c.host=\$$vname" >> $workers_propfile
 vname=Tomcat_${c}_portAJP
 eval "echo worker.worker$c.port=\$$vname" >> $workers_propfile
 echo worker.worker$c.lbfactor=1 >> $workers_propfile
done

# (re)start apache
apache2ctl restart

