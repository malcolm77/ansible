#!/bin/bash

readonly MEASUREMENT="software_inventory"
readonly HOSTNAME=$(hostname)
readonly IPADDRESS=$(hostname -I | cut -d' ' -f1)
readonly KERNEL=$(uname -r)
readonly OS=$(grep -E "^NAME=" /etc/os-release | cut -d'=' -f2 | sed 's/\"//g')
readonly OS_VERSION=$(grep -E "^VERSION=" /etc/os-release | cut -d '=' -f2 | sed 's/\"//g')

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

function inventory_ubuntu(){

 # shellcheck disable=SC2034
 dpkg-query --list | grep '^ii' | while read -r pState package pVer pArch pDesc;do
        #  printf "$format" "$pState" "${package:0:30}" "${pVer:0:30}" "${pArch:0:6}" "${pDesc:0:60}"

        pkg=$(echo "$package" | cut -d':' -f1)
        license="unknown"

        if [ -f /usr/share/doc/"$pkg"/copyright ]; then
            #  license=$(awk '/^License:/ { print $2 }' /usr/share/doc/$pkg/copyright | sort -u)
            license=$(grep "^License:" "/usr/share/doc/${pkg}/copyright" | cut -d':' -f 2 | sort -u | tr -d '\n\r' )
        fi
        #echo "{ \"Package\" : {\"datetime\" : \"$NOW\",\"hostname\" : \"$HOSTNAME\",\"ipaddress\": \"$IP\",\"OS\": \"$OS\",\"OSVersion\": \"$OS_VERSION\",\"kernel\": \"$KERNEL\", \"name\" : \"${package:0:30}\",\"version\" : \"${pVer:0:30}\", \"license\" : \" ${license:0:30} \", \"arch\" : \"${pArch:0:30}\" } }" >> /tmp/software.json.ubuntu
        #echo "Package: ${package:0:30} ; Version: ${pVer:0:30} ; License : ${license:0:30}" >> /tmp/software.txt.ubuntu
        installed_date=$(sudo zgrep -h " installed " /var/log/dpkg.log* | grep "installed ${package}:" | grep "$pVer" | sort -r | head -n1 | cut -d' ' -f1,2)
        additional_info=$(sudo dpkg-query --showformat='${Maintainer}#${Architecture}#${Installed-Size}' --show "$package")
        printf '%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s\n' "$MEASUREMENT" "$HOSTNAME" "$IPADDRESS" "$KERNEL" "$OS" "$OS_VERSION" "${package:0:30}" "${pVer:0:30}" "${license:0:30}" "$installed_date" "$additional_info"
    done
 
 #sudo dpkg-query --showformat="$MEASUREMENT#$HOSTNAME#$IPADDRESS#$KERNEL#$OS#$OS_VERSION#${Package}#${Version}#License#${Maintainer}#${Architecture}#${installtime:date}#${Installed-Size}\n"
}

function inventory_rhel() {
  # format MEASUREMENT TAGSET METRICSET  
  rpm -qa --qf "$MEASUREMENT#$HOSTNAME#$IPADDRESS#$KERNEL#$OS#$OS_VERSION#%{NAME}#%{VERSION}#%{LICENSE}#%{installtime:date}#%{VENDOR}#%{ARCH}#%{size}\n"
}

function main() {

  # determine the OS 
  os_type

  case $OS_TYPE in
  "ubuntu")
    inventory_ubuntu
  ;;
  "rhel")
    inventory_rhel
  ;;
  *)
    # not supported
    return
  ;;
  esac

}


main "$@"
