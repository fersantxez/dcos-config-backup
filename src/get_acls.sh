#!/bin/bash
# get_acls.sh: retrieve and save configured ACLs on a DC/OS cluster
#
# Author: Fernando Sanchez [ fernando at mesosphere.com ]
#
# Get a set of ACLs configured in a running DC/OS cluster, and save
# them to a file in raw JSON format for backup and restore purposes.
# These can be restored into a cluster with the accompanying 
# "post_acls.sh" script.

#reference: 
#https://docs.mesosphere.com/1.8/administration/id-and-access-mgt/iam-api/#!/permissions/get_acls

#Load configuration if it exists
#config is stored directly in JSON format in a fixed location
CONFIG_FILE=$PWD"/.config.json"
if [ -f $CONFIG_FILE ]; then
  
  DCOS_IP=$(cat $CONFIG_FILE | jq -r '.DCOS_IP')
  ACLS_FILE=$(cat $CONFIG_FILE | jq -r '.ACLS_FILE')
  TOKEN=$(cat $CONFIG_FILE | jq -r '.TOKEN')

else

  echo "** ERROR: Configuration not found. Please run ./run.sh first"

fi

#get ACLs from cluster
ACLS=$( curl \
-H "Content-Type:application/json" \
-H "Authorization: token=$TOKEN" \
-X GET \
http://$DCOS_IP/acs/api/v1/acls )

#save to file
touch $ACLS_FILE
echo $ACLS > $ACLS_FILE

#debug
echo "** ACLs: "
echo $ACLS | jq

echo "Done."
