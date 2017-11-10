#!/bin/bash

apt-get update

apt-get -y install tomcat7
cp $ROBOCONF_FILES_DIR/server.xml /etc/tomcat7

service tomcat7 stop

cat << EOF > /var/lib/tomcat7/webapps/ROOT/index.html
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <title>Apache Tomcat</title>
</head>

<body>
<h1>It works !</h1>
<p>From Tomcat at: $ip</p>

</body>
</html>
EOF
