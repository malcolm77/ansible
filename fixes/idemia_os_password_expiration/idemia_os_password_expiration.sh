#!/bin/bash

###############################################################################
#
# /home/ansible/scripts/check-password-expiration.sh
# This script get all the account password expiration dates
# and writes this information to /tmp/node/idemia_os_password_expiration.prom
# for Prometheus to pick up
#
#################################################################################

readonly NOW=$(date +"%s")

function check_expiration() {
  for i in `cat /etc/passwd | cut -d ':' -f 1`
  do
     USER=$i
     EXPIRATION=$(sudo chage -l $i | sed -n '2p' | cut -d ':' -f 2)
     if [ "$EXPIRATION" != " never" ]
     then
       CONVERT_EXPIR=$(date -d "$EXPIRATION" +"%s")
       EXPIRE_DAYS=$((($CONVERT_EXPIR-$NOW)/(3600*24)))
       DELAY_EXPIR=$(printf %.0f\\n "$((((($CONVERT_EXPIR-$NOW)/60)/60)/24))")
         if [ "$DELAY_EXPIR" -le 0 ]
         then
           DELAY_EXPIR=0
         fi
     else
       DELAY_EXPIR=999
       CONVERT_EXPIR=0
     fi
     echo "idemia_os_password_expiration{user=\""$USER"\"} "$EXPIRE_DAYS
  done
}

function main() {
   check_expiration
}

main "$@"

