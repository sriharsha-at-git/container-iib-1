#!/bin/bash
# © Copyright IBM Corporation 2015.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html

set -e

NODE_NAME=${NODENAME-IIBV10NODE}
NODE_SERVER=SERVER_SOAP

stopNode()
{
	echo "----------------------------------------"
	echo "Stopping node $NODE_NAME..."
	mqsistop $NODE_NAME
}

startNode()
{
	echo "----------------------------------------"
	echo "Starting node $NODE_NAME..."
	mqsistart $NODE_NAME
}


createNode()
{
	echo "----------------------------------------"
  /opt/ibm/iib-10.0.0.8/iib version
	echo "----------------------------------------"

  NODE_EXISTS=`mqsilist | grep $NODE_NAME > /dev/null ; echo $?`


	if [ ${NODE_EXISTS} -ne 0 ]; then
    echo "----------------------------------------"
    echo "Node $NODE_NAME does not exist..."
    echo "Creating node $NODE_NAME"
		mqsicreatebroker $NODE_NAME
    echo "----------------------------------------"
	fi
	echo "----------------------------------------"
	echo "Starting syslog"
	sudo /usr/sbin/rsyslogd
	echo "Starting node $NODE_NAME"
	mqsistart $NODE_NAME
	echo "----------------------------------------"
}

createServer()
{
	echo "----------------------------------------"
	/opt/ibm/iib-10.0.0.8/iib version
	echo "----------------------------------------"

  SERVER_EXISTS=`mqsilist $NODE_NAME | grep $NODE_SERVER > /dev/null ; echo $?`

	if [ ${SERVER_EXISTS} -ne 0 ]; then
    echo "----------------------------------------"
    echo "Node $SERVER_WS does not exist..."
    echo "Creating node $SERVER_WS"
		mqsicreateexecutiongroup $NODE_NAME -e $NODE_SERVER
	echo "----------------------------------------"
	fi
}

deployBars()
{
	echo "Deploying iib archives to server $SERVER_WS"
	echo "----------------------------------------"
		mqsideploy $NODE_NAME -e $NODE_SERVER -a /tmp/BARfiles/RestCustomerDatabaseV1.bar
		mqsideploy $NODE_NAME -e $NODE_SERVER -a /tmp/BARfiles/SoapCustomerSuperV1.bar
	echo "----------------------------------------"
}

initSecurity()
{
	echo "Set up security for Web UI"
	echo "----------------------------------------"
	echo "-- mqsichangeauthmode $NODE_NAME -s active -m file --"
			mqsichangeauthmode $NODE_NAME -s active -m file
	echo "----------------------------------------"
	echo "-- mqsireportauthmode $NODE_NAME --"
		mqsireportauthmode $NODE_NAME
	echo "----------------------------------------"
	echo "-- mqsichangefileauth $NODE_NAME -r iibadmins -p all+ --"
		mqsichangefileauth $NODE_NAME -r iibadmins -p all+
		mqsichangefileauth $NODE_NAME -r iibadmins -e $NODE_SERVER -p all+
	echo "----------------------------------------"
	echo "-- mqsichangefileauth $NODE_NAME -r iibusers -p read+ --"
		mqsichangefileauth $NODE_NAME -r iibusers -p read+
		mqsichangefileauth $NODE_NAME -r iibusers -e $NODE_SERVER -p read+
	echo "----------------------------------------"
	echo "--mqsireportfileauth $NODE_NAME -l --"
		mqsireportfileauth $NODE_NAME -l
	echo "----------------------------------------"
}

setWebSecurity()
{
	echo "----------------------------------------"
	echo "-- mqsiwebuseradmin $NODE_NAME -c -u iibwebadmin -r iibadmins -a passw0rd --"
	echo "-- mqsiwebuseradmin $NODE_NAME -c -u iibwebuser -r iibusers -a passw0rd --"
		mqsiwebuseradmin $NODE_NAME -c -u iibwebadmin -r iibadmins -a passw0rd
		mqsiwebuseradmin $NODE_NAME -c -u iibwebuser -r iibusers -a passw0rd
	echo "----------------------------------------"
	echo "-- mqsiwebuseradmin $NODE_NAME -m -u iibwebadmin -a iibwebadminpwd --"
	echo "-- mqsiwebuseradmin $NODE_NAME -m -u iibwebuser -a iibwebuserpwd --"
		mqsiwebuseradmin $NODE_NAME -m -u iibwebadmin -a iibwebadminpwd
		mqsiwebuseradmin $NODE_NAME -m -u iibwebuser -a iibwebuserpwd
	echo "----------------------------------------"
}

monitor()
{
	echo "----------------------------------------"
	echo "Running - stop container to exit"
	# Loop forever by default - container must be stopped manually.
  # Here is where you can add in conditions controlling when your container will exit - e.g. check for existence of specific processes stopping or errors beiing reported
	while true; do
		sleep 1
	done
}

iib-license-check.sh
createNode
createServer
deployBars
stopNode
initSecurity
startNode
setWebSecurity
trap stop SIGTERM SIGINT
monitor
