#!/bin/sh
#
# Monitore the MBIS services running on the host
# Retrieve the status of each services running on this host
# Result sent back with influxdb format
#  - Status Value 10 : Running
#  - Status Value 13 : Failed (Service running but not working, dependencies issue)
#  - Status Value 14 : Not Running
#
# /usr/local/bin/telegraf/probes/service_bis.sh
#
##############

# Variables
##
v_host=$(hostname)
v_BisHome="/opt/bis"
v_BisScripts="${v_BisHome}/scripts"
v_ListServices=""
v_des=""
v_sts=""

v_ServiceResult=""
v_ServiceState=""
v_DesService=""
v_StsService=""
v_ServiceResultArtemis=""
v_ServiceResultJboss=""
v_testRedhatSSO=""

# List of MBIS RPM to search:
# - bis-artemis         => Value : Artemis (Replaced by WSD on MBIS 5.12)
# - bis-wms             => Value : Wms     (On MBIS 5.12 and higher)
# - bis-wildfly         => Value : Wildfly
# - bis-wfs             => Value : Wfs
# - bis-cva             => Value : Cva
# - bis-cps             => Value : Cps
# - bis-dsm             => Value : Dsm
# - bis-pcs             => Value : Pcs
# - bis-wfmcl           => Value : Wfmcl
# - bis-tera            => Value : Tera
# - bis-fes             => Value : Fes
# - bis-sts             => Value : Sts
# - bis-des             => Value : Des
# - bis-redhatsso       => Value : RedhatSSO (Must be set before Keycloak value)
# - bis-keycloak        => Value : Keycloak (Must be set after ReshatSSO - If redhatSSO already installed, keycloak is skipped)
# - bis-rps             => Value : Rps

############################  Needs to be customized on each machine ###################################
v_MBISRPMListing="Artemis Wms Wildfly Wfs Cva Cps Dsm Pcs Wfmcl Tera Fes Sts Des RedhatSSO Keycloak Rps"


############################################################
#                       Main
############################################################

############################################################
##  Creating the list of services hosted 
############################################################

for l_rpm in ${v_MBISRPMListing}
do
        # Exception for DES and STS Services
        # if [ `rpm -qa | grep -i bis-${l_rpm} | wc -l` -gt 0 ] ---- Causes a CPU spike (6% - 40%) everytime the script is run
        if [ `rpm -qa | grep -i bis-${l_rpm} | wc -l` -gt 0 ]
        then
                # Exception for STS
                if [ "${l_rpm}" == "Sts" ]
                then
                        for v_sts in `sudo -u bis ${v_BisScripts}/StsQueues | awk '{print $1}'`
                        do
                                v_ListServices="Sts-${v_sts} ${v_ListServices}"
                        done

                # Exception for DES
                elif [ "${l_rpm}" == "Des" ]
                then
                        for v_des in `sudo -u bis ${v_BisScripts}/DesList | awk '{print $1}'`
                        do
                                v_ListServices="Des-${v_des} ${v_ListServices}"
                        done

                # Exception for JBOSS
                elif [ "${l_rpm}" == "Wildfly" ]
                then
                        v_ListServices="AppServer ${v_ListServices}"

                # Exception for CentralView
                elif [ "${l_rpm}" == "Cva" ]
                then
                        v_ListServices="CentralView ${v_ListServices}"

                # Exception for Keycloak and RedhatSSO
                elif [ "${l_rpm}" == "Keycloak" ]
                then
                        v_testRedhatSSO=`echo ${v_ListServices} | grep  "RedhatSSO"`
                        if [ -z "${v_testRedhatSSO}" ]
                        then
                                v_ListServices="${l_rpm} ${v_ListServices}"
                        fi

                # No more exceptions, let's go !
                else
                        v_ListServices="${l_rpm} ${v_ListServices}"
                fi
        fi
done

############################################################
## Now check the status of each of the services detected
############################################################

for l_service in ${v_ListServices}
do
        # Check if the service is a DES
        if [ "${l_service:0:3}" == "Des" ]
        then
                v_DesService=`echo ${l_service} | cut -d "-" -f 2-`
                v_ServiceResult=`sudo -u bis ${v_BisScripts}/${l_service:0:3}Show ${v_DesService} | grep -i running`
        elif [ "${l_service:0:3}" == "Sts" ]
        then
                v_StsService=`echo ${l_service} | cut -c 5-`
                v_ServiceResult=`sudo -u bis ${v_BisScripts}/${l_service:0:3}Show ${v_StsService} | grep -i running`
        else
                v_ServiceResult=`sudo -u bis ${v_BisScripts}/${l_service}Show | grep -i running`
        fi

        # Check the status of the service (Running/Stopped only)
        if [ -z "${v_ServiceResult}" ]
        then
                v_ServiceState=14
        else
                v_ServiceState=10
        fi

        # Display the result on influxdb format
        echo "services_bis,host=${v_host},display_name=${l_service},service_name=${l_service} state=${v_ServiceState}"

        #Init Variables
        v_DesService=""
        v_ServiceResult=""
        v_ServiceState=""
done


