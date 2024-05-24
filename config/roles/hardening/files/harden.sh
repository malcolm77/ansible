/bin/bash /tmp/RHEL_HARDENING/scripts/run.sh -a -c /tmp/RHEL_HARDENING/scripts/config/rhel8/CIS_V1.0.0/CIS_Common.cfg -r /tmp/RHEL_HARDENING/scripts/config/rhel8/CIS_V1.0.0/CIS_Level_1.rs -o /home/ansible/$HOSTNAME-hardening-report.txt
chown ansible.ansible /home/ansible/$HOSTNAME-hardening-report.txt
systemctl restart iptables
systemctl restart firewalld
systemctl restart sssd
