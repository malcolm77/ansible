Role Use
=========
These playbooks are used to configure a new server

Requirements
------------
Ansible 2.9

Role Variables
--------------

base            - Does a number of the roles below (hosts, repo, resolv, timezone, banner, time)
hosts		- replace the hosts file with the one from the ansible server
repo		- replace the repo file with the one from the ansible server
resolv		- replace the resolv file with the one from the ansible server
timezone	- set the timezone to sydney australia
ssh		- set the SSH banner to the the ACIC banner and set AllowGroups 
time		- set chrony to user DB1 as the time source
node		- install node_exporter and configure prometheus on #04 to poll it
harden          - copy and run hardening scripts
mail		- setup email/postfix
firewall        - open required firewall ports
AD              - install some services and copy some configuration files to the server, 
                  the /tmp/join-ad.sh script will need to be run manually on the server to complete
tenable         - grant the domain\svc_tenable account ssh and sudo access
sudoers         - correctly config the /etc/sudoers files
logrotate	- copy MBSS and MBIS logrotate config files to server



Dependencies
------------
nil

Example Playbook
----------------
eg. # ansible-playbook --ask-vault-password -l SERVER config.yml --tags=base

FYI : site.yml may be set to do 1 server at a time, check before executing

License
-------
BSD

Author Information
------------------
malcolm.chalmers@idemia.com
