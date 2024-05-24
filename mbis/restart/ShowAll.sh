#!/bin/bash

# Script to run the show scripts for any install MBIS service
# Used for testing before doing the same with the startup and shutdown scripts

echo "Enter SVC_ANSIBLE password"
ansible-playbook showall.yml -K
