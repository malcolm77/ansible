
###################################################################
# This is a list of Ansible scripts for use by support staff
# Most scripts will need to be run with in the following manner
#
# $ ansible-playbook -K <scriptname>
#
# and it will then prompt you for the svc_ansible password
# which is in the KeePass file
#
# Below is description of each script
#
#################################################################### 


README.txt
- This file

start-alertmanager.yml
- Start the alertmanager service in PDC and SDC

stop-alertmanager.yml
- Stop the alertmanager service in PDC and SDC, this basically disables alerting

ping.yml
- A script to simply ping all the severs to test connection and credentials


