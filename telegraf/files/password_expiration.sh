#!/bin/bash

readonly MEASUREMENT="password_expiration"
readonly HOSTNAME=$(hostname)
readonly KERNEL=$(uname -r)
readonly OS=$(grep -E "^NAME=" /etc/os-release | cut -d'=' -f2 | sed 's/\"//g')
readonly OS_VERSION=$(grep -E "^VERSION=" /etc/os-release | cut -d '=' -f2 | sed 's/\"//g')
readonly NOW=$(date +"%s")
readonly v_TimeStamp=$(($(date +%s%N)))

function os_type() {

 OS_TYPE=$(uname)

 case $OS_TYPE in
 Linux )
 #  echo "[INFO] OS Linux supported ..."
   command -v yum > /dev/null && OS_TYPE="rhel"
   command -v zypper > /dev/null && OS_TYPE="opensuse"
   command -v apt-get > /dev/null && OS_TYPE="ubuntu"
   ;;
 Darwin )
 #  echo "[ERROR] OS Mac not supported ..."
   exit 1
   ;;
 * )
 #  echo "[ERROR] OS not supported..."
   exit 1
   ;;
 esac
}

function check_expiration() {

for i in `cat /etc/passwd | cut -d ':' -f 1`
do
   USER=$i
   EXPIRATION=$(sudo chage -l $i | sed -n '2p' | cut -d ':' -f 2)
   if [ "$EXPIRATION" != " never" ]
   then
     CONVERT_EXPIR=$(date -d "$EXPIRATION" +"%s")
     DELAY_EXPIR=$(printf %.0f\\n "$((((($CONVERT_EXPIR-$NOW)/60)/60)/24))")
       if [ "$DELAY_EXPIR" -le 0 ]
       then
         DELAY_EXPIR=0
       fi
   else
     DELAY_EXPIR=999
     CONVERT_EXPIR=0
   fi
   echo "password_expiration#$HOSTNAME#$OS#$OS_VERSION#$USER#$CONVERT_EXPIR#$DELAY_EXPIR"
 
   # curl -i -XPOST 'http://RBIMM-VPD-PNG13:8086/write?db=SYSTEM' --data-binary "password_expiration,host=$HOSTNAME,os=$OS,user=$USER value=$DELAY_EXPIR $v_TimeStamp"

done

}

function main() {

  # determine the OS
  os_type

  case $OS_TYPE in
  "ubuntu")
    check_expiration
  ;;
  "rhel")
    check_expiration
  ;;
  *)
    # not supported
    return
  ;;
  esac

}


main "$@"
