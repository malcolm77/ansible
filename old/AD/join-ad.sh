#!/bin/bash

###### install required allications
yum install -y adcli sssd authconfig

######## join domain
adcli join --domain=nafis.cicz.gov.au --domain-controller=SERVER01.nafis.cicz.gov.au --login-user=username

######### copy updated krb5.conf file to proper location
cp /tmp/krb5.conf /etc/krb5.conf

######### authorize sssd
authconfig --enablesssd --enablesssdauth --enablemkhomedir --update

####### copy sssd.conf file to proper location and set permissions
cp /tmp/sssd.conf /etc/sssd/sssd.conf
chown root:root /etc/sssd/sssd.conf
chmod 0600 /etc/sssd/sssd.conf

######### start sssd service
systemctl start sssd

####### add tier1 to suoders file################
echo "%domain.domain.au\\\\tier1_linux_admin ALL=(ALL) ALL" >> /etc/sudoers

############ Reconfig sshd_config ################
# comment out AllowUsers
sed -i 's/^AllowUsers/#&/' /etc/ssh/sshd_config
# Add tier1 to AllowGroups
sed -i '/AllowGroups/ s/$/ tier1_linux_admin/' /etc/ssh/sshd_config
# set PermitRootLogin to No
sed -i 's/PermitRootLogin [Yy]es/PermitRootLogin no/g' /etc/ssh/sshd_config

# Restart ssh
systemctl restart sshd

# display current status for services
systemctl status sssd
systemctl status sshd
