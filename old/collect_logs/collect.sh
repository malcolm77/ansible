#!/usr/bin/bash

#####################################################################
##
## Scripts to collect all the log MBIS and MBSS log files for France
##
#####################################################################

# Collect LOG files
/usr/bin/ansible-playbook mbis-logs.yml

# Collect OUT files
/usr/bin/ansible-playbook mbis-out.yml

# Collect TD-Agent/Scribe log files from PNG40
/usr/bin/ansible-playbook mbss-logs.yml


# Clean log files of VSD names
echo "############################# Clean log files of VSD names ###############################"
find /all_logs -name "*.log" -exec sed -i 's/SERVER/SERVER/g' {} \;
find /all_logs -name "*.out" -exec sed -i 's/SERVER/SERVER/g' {} \;

# Clean log files of SDC names
echo "############################# Clean log files of SDC names ###############################"
find /all_logs -name "*.log" -exec sed -i 's/SERVER/SERVER/g' {} \;
find /all_logs -name "*.out" -exec sed -i 's/SERVER/SERVER/g' {} \;

# Clean log files of DB names
echo "############################# Clean log files of DBM names ###############################"
find /all_logs -name "*.log" -exec sed -i 's/SERVER/DBM/g' {} \;
