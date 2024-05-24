#!/bin/bash

#     "msg": "Server RBIAS-VSD-PNG01 - firewall is inactive"

ansible-playbook --ask-vault-pass firewall-status.yml | grep "firewall"

# attempt to tidy it up even more
# awk '/firewall/ { print $3 " : " $7 }'

