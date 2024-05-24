export LD_LIBRARY_PATH=/oracle/19c/database/lib:
export ORACLE_SID=PREPROD
export ORACLE_BASE=/oracle/oraBase
export LANG=en_US
export HISTCONTROL=ignoredups
export ORACLE_HOME=/oracle/19c/database
export HOSTNAME=RBIDB-SDC-PNG01
export S_COLORS=auto
export CLASSPATH=/oracle/19c/database/JRE:/oracle/19c/database/jlib:/oracle/19c/database/rdbms/jlib
export TMP=/tmp
export NLS_LANG=AMERICAN_AMERICA.UTF8
export TMPDIR=/tmp
export LIBPATH=/oracle/19c/database/lib:
export USE_MULTITENANT=TRUE
export MAIL=/var/spool/mail/oracle
export SHELL=/bin/bash
export TERM=xterm
export TNS_ADMIN=/oracle/19c/database/network/admin
export TMOUT=900
export SHLVL=1
export TEMP=/tmp
export ORACLE_HOSTNAME=RBIDB-SDC-PNG01
export PATH=/oracle/19c/database/bin:/oracle/19c/database/perl/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:$PATH
export HISTSIZE=1000
export LESSOPEN=||/usr/bin/lesspipe.sh %s

/oracle/19c/database/bin/sqlplus system/YrrF7Y52NPfZWJxBw7Jh@PREPRODPDB @/usr/local/bin/telegraf/probes/wfm_workflow_queuecount.sql | grep workflowqueuecount
