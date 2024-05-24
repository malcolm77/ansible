# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
export LANG=en_US
export ORACLE_BASE=/oracle/oraBase
export TEMP=/delivery
export TMP=/delivery
export TMPDIR=/delivery
export ORACLE_HOME=/oracle/19c/grid
export TNS_ADMIN=$ORACLE_HOME/network/admin
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
export CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
export PATH=$ORACLE_HOME/bin:$PATH
set -o vi
umask 0022
