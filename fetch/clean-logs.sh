#!/bin/bash

# Clean log files
find /data/logs -type f -name "*" -print -exec sed -i 's/SERVER/SERVER/Ig' {} \;  -exec sed -i 's/\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}/xxx.xxx.xxx.xxx/g' {} \; -exec sed -i 's/nafis.cicz.gov.au/domain.name.au/Ig' {} \; -exec sed -i 's/pidm......\..../username/Ig' {} \;
