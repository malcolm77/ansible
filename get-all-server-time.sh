#!/bin/bash

echo "========================================= Get time on all servers ====================================="
ansible-playbook timestamp.yml | awk '/current time/ { print $2": "$5 }'
