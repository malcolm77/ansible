#!/bin/bash

##############################################################################
#
# Script to turn on the firewall and add rules 
# via shell script
#
# It is preferred to use the ansible script, only use this if you have to
#
##############################################################################

# Turn firewall on
systemctl enable --now firewalld

# Add rules
firewall-cmd --add-rich-rule='rule family="ipv4" source address="xxx.xxx.xxx.xxx/24" accept' --perm
firewall-cmd --add-rich-rule='rule family="ipv4" source address="xxx.xxx.xxx.xxx/24" accept' --perm
firewall-cmd --add-rich-rule='rule family="ipv4" source address="xxx.xxx.xxx.xxx/24" accept' --perm
firewall-cmd --add-rich-rule='rule family="ipv4" source address="xxx.xxx.xxx.xxx/24" accept' --perm
firewall-cmd --add-rich-rule='rule family="ipv4" source address="xxx.xxx.xxx.xxx/24" accept' --perm
firewall-cmd --add-rich-rule='rule family="ipv4" source address="xxx.xxx.xxx.xxx/24" accept' --perm
firewall-cmd --add-rich-rule='rule family="ipv4" source address="xxx.xxx.xxx.xxx/24" accept' --perm
firewall-cmd --add-rich-rule='rule family="ipv4" source address="xxx.xxx.xxx.xxx/24" accept' --perm
firewall-cmd --add-rich-rule='rule family="ipv4" source address="xxx.xxx.xxx.xxx/24" accept' --perm
firewall-cmd --add-rich-rule='rule family="ipv4" source address="xxx.xxx.xxx.xxx/24" accept' --perm
firewall-cmd --add-rich-rule='rule family="ipv4" source address="xxx.xxx.xxx.xxx/24" accept' --perm
firewall-cmd --add-rich-rule='rule family="ipv4" source address="xxx.xxx.xxx.xxx/24" accept' --perm
firewall-cmd --add-rich-rule='rule family="ipv4" source address="xxx.xxx.xxx.xxx/24" accept' --perm
firewall-cmd --add-rich-rule='rule family="ipv4" source address="xxx.xxx.xxx.xxx/24" accept' --perm
firewall-cmd --add-rich-rule='rule family="ipv4" source address="xxx.xxx.xxx.xxx/24" accept' --perm
firewall-cmd --add-rich-rule='rule family="ipv4" source address="xxx.xxx.xxx.xxx/24" accept' --perm
firewall-cmd --add-rich-rule='rule family="ipv4" source address="xxx.xxx.xxx.xxx/24" accept' --perm

# Reload firewall (to make sure rules are loaded
firewall-cmd --reload
