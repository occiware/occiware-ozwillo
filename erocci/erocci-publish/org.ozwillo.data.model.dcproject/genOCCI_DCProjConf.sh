#!/bin/sh

SERVER=$1
today=$(date +%Y%m%d.%H)
LOG_RESP="genOCCI_DCProjConf.$today.log"

echo "Starting POSTting the configuration in erOCCI server : " $SERVER
#http://localhost:XXXXX/collections/resourceName/
echo "*************************************************************************:::" $(date)
echo "\n:::::::::::::::::::::::::::::::" $(date) "::::::::::::::::::::::::\n\n" >> $LOG_RESP
echo "..............POST resources (Project / Model)................."

#Project/Model curl
URL=$SERVER/collections/project/
KIND='http://occiware.org/ozwillo/dcproject#project'
ATTRIBUTES='{"name":"occiware_org_0","frozenModelNames":"[*]",}'
echo "URL: " $URL
echo "ATTRIBUTES: " $ATTRIBUTES
echo "KIND: " $KIND
echo "Resource: '"'{ "resources":[ { "kind":' '"'$KIND'", "attributes":' $ATTRIBUTES' } ] }' "'"
echo '{ "resources":[ { "kind":' '"'$KIND'", "attributes":' $ATTRIBUTES' } ] }' | curl -v -H 'content-type: application/json' -X POST --data-binary @- $URL 2>> $LOG_RESP
#Links curl


echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
#Project/Model curl
URL=$SERVER/collections/model/
KIND='http://occiware.org/ozwillo/dcproject#model'
ATTRIBUTES='{"name":"Activity_0","version":"0","majorVersion":"0",}'
echo "URL: " $URL
echo "ATTRIBUTES: " $ATTRIBUTES
echo "KIND: " $KIND
echo "Resource: '"'{ "resources":[ { "kind":' '"'$KIND'", "attributes":' $ATTRIBUTES' } ] }' "'"
echo '{ "resources":[ { "kind":' '"'$KIND'", "attributes":' $ATTRIBUTES' } ] }' | curl -v -H 'content-type: application/json' -X POST --data-binary @- $URL 2>> $LOG_RESP
#Links curl


echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
#Project/Model curl
URL=$SERVER/collections/model/
KIND='http://occiware.org/ozwillo/dcproject#model'
ATTRIBUTES='{"name":"Organization_0","version":"0","majorVersion":"0",}'
echo "URL: " $URL
echo "ATTRIBUTES: " $ATTRIBUTES
echo "KIND: " $KIND
echo "Resource: '"'{ "resources":[ { "kind":' '"'$KIND'", "attributes":' $ATTRIBUTES' } ] }' "'"
echo '{ "resources":[ { "kind":' '"'$KIND'", "attributes":' $ATTRIBUTES' } ] }' | curl -v -H 'content-type: application/json' -X POST --data-binary @- $URL 2>> $LOG_RESP
#Links curl


echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
#Project/Model curl
URL=$SERVER/collections/model/
KIND='http://occiware.org/ozwillo/dcproject#model'
ATTRIBUTES='{"name":"geoArea_0","version":"0","majorVersion":"0",}'
echo "URL: " $URL
echo "ATTRIBUTES: " $ATTRIBUTES
echo "KIND: " $KIND
echo "Resource: '"'{ "resources":[ { "kind":' '"'$KIND'", "attributes":' $ATTRIBUTES' } ] }' "'"
echo '{ "resources":[ { "kind":' '"'$KIND'", "attributes":' $ATTRIBUTES' } ] }' | curl -v -H 'content-type: application/json' -X POST --data-binary @- $URL 2>> $LOG_RESP
#Links curl


echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

baseURL_project=$SERVER/collections/project/
baseURL_model=$SERVER/collections/model/
baseURL_link=$SERVER/collections/geoAreaModelToProjectLink/
echo "..............Fetch ALL existing resources................."
echo "PROJECTS:" ; curl -sb -v -H 'accept: text/uri-list' $baseURL_project
echo "MODELS:" ; curl -sb -v -H 'accept: text/uri-list' $baseURL_model
echo "TO REMOVE THEM : curl -X DELETE " $baseURL_project "; curl -X DELETE " $baseURL_model
echo "TO LIST THEM : curl -v -H 'accept: text/uri-list' $baseURL_project"
echo "     OR : curl -X GET $baseURL_project"
  
echo "Finish POSTting the confirguation in erOCCI server. Check responses in log : " $LOG_RESP
echo "*************************************************************************:::"
