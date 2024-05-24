#!/bin/bash

# get latents count
sudo -u mbssadmin /opt/mbss/tools/sadmin.sh -count -latents | awk '/Total count of Ids loaded:/ { print "mbsscount,PDC,latents," $15 }'

