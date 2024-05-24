#!/bin/bash
######################################################
# /root/scripts/get_connections.sh
# this script will get the number of database connections
# and post that number to the InfluxDB running on the
# monitoring server
#
######################################################

# Get the number of connections for each database
DBCONNS=$(ps aux | grep "(LOCAL" | grep PROD2 | wc -l)

# echo to screen (optional)
# echo "PROD2 has $MAPDBCONNS connections"

# generate time stamp
TIMESTAMP=$(($(date +%s%N)))

# post to database
#curl -i -XPOST 'http://SERVER09:8086/write?db=nafis' --data-binary "connectioncount,site=NODE1,database=MAPDB value=$MAPDBCONNS $TIMESTAMP"
echo "databaseconnections,PROD2,$DBCONNS"

