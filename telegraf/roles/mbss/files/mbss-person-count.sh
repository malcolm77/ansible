#!/bin/bash

# get persons count
sudo -u mbssadmin /opt/mbss/tools/sadmin.sh -count -persons | awk '/Total count of Ids loaded:/ { print "mbsscount,PDC,persons," $15 }'
