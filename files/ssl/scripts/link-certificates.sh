#!/bin/sh

# DESCRIPTION
# Script to link all relevant keystore, truststore and .p12 files in MBIS

function usage {
    echo ""
    echo "******************** Usage *************************"
    echo "Ensure .keystore .truststore and .p12 file are present in the opt/bis/ssl/environment folder"
    echo "$0 <path to opt/ssl/environment/service> <path to opt/ssl/environment/service2> <path to n service> "
    echo "Script can accept any number of paths as arguments"
    echo "****************************************************"
    echo "Service options: "
    echo "- elk (Required file(s): .p12)"
    echo "- NextgenAPI (Required file(s): .keystore, .truststore)"
    echo "- bis2ebis (Required file(s): .keystore, .truststore)"
    echo "- keycloak (Required file(s): .keystore, .truststore)"
    echo "- wildfly (Required file(s): .keystore, .truststore, .p12)"
    echo "- wms (Required file(s): .keystore, .truststore)"
    echo "*****************************************************"
    exit 1
}

verify_directory () {
    if [ ! -d $1 ]
    then
    echo "Not a directory: $1" >&2
    # exit 1
    fi
}

# Following is to get BIS_HOME

. /etc/sysconfig/MORPHO_BIS

if [ -v $BIS_HOME ]
then
   echo "Envvar BIS_HOME is not set/exported" >&2
   exit 1
fi

# Variables
BIS_ETC="$BIS_HOME/etc"
ROOT_ETC="/etc"
WILDFLY_DIR="$BIS_HOME/jboss/standalone/configuration"
WMS_DIR="$BIS_HOME/wms/etc"
KEYCLOAK_DIR="$BIS_HOME/keycloak/standalone/configuration"
PW="Morphotrak"

echo "Verifying directories..."
for dir in $BIS_HOME $BIS_ETC $WILDFLY_DIR $WMS_DIR $@
do
    verify_directory $dir
done

link_wildfly () {
    FOLDER=$1
    for EXTENSION in ".keystore" ".truststore" ".p12"
    do
        for FILEPATH in $(find $FOLDER -type f -name "*$EXTENSION")
        do
            if [[ $FILEPATH == *.keystore ]]
            then
                echo "Linking Keystore..."
                ln -sf $FILEPATH "$BIS_ETC/server.keystore"
                echo "$BIS_ETC/server.keystore linked"

                ln -sf $FILEPATH "$WILDFLY_DIR/wildfly.keystore"
                echo "$WILDFLY_DIR/wildfly.keystore linked"
            fi

            if [[ $FILEPATH == *.truststore ]]
            then
                echo "Linking Truststore..."
                ln -sf $FILEPATH "$BIS_ETC/client.truststore"
                echo "$BIS_ETC/client.truststore linked"

                # ln -sf $FILEPATH "$WILDFLY_DIR/wildfly.truststore"
                # echo "$WILDFLY_DIR/wildfly.truststore linked"
            fi

            if [[ $FILEPATH == *.p12 ]]
            then
                echo "Linking p12..."
                ln -sf $FILEPATH "$BIS_ETC/client.p12"
                echo "$BIS_ETC/client.p12 linked"
            fi
        done
    done
}

link_wms () {
    FOLDER=$1
    for EXTENSION in ".keystore" ".truststore"
    do
        for FILEPATH in $(find $FOLDER -type f -name "*$EXTENSION")
        do
            if [[ $FILEPATH == *.keystore ]]
            then
                echo "Linking Keystore..."
                ln -sf $FILEPATH "$WMS_DIR/wms.keystore"
                echo "$WMS_DIR/wms.keystore linked"
            fi

            if [[ $FILEPATH == *.truststore ]]
            then
                echo "Linking Truststore..."
                ln -sf $FILEPATH "$WMS_DIR/wms.truststore"
                echo "$WMS_DIR/wms.truststore linked"
            fi
        done
    done
}

link_keycloak () {
    FOLDER=$1
    for EXTENSION in ".keystore" ".truststore"
    do
        for FILEPATH in $(find $FOLDER -type f -name "*$EXTENSION")
        do
            if [[ $FILEPATH == *.keystore ]]
            then
                echo "Linking Keystore..."
                ln -sf $FILEPATH "$KEYCLOAK_DIR/mbiskeycloak.keystore"
                echo "$KEYCLOAK_DIR/mbiskeycloak.keystore linked"
            fi

            if [[ $FILEPATH == *.truststore ]]
            then
                echo "Linking Truststore..."
                ln -sf $FILEPATH "$KEYCLOAK_DIR/mbiskeycloak-client.truststore"
                echo "$KEYCLOAK_DIR/mbiskeycloak-client.truststore linked"
            fi
        done
    done
}

extract_key () {
    echo "Extracting private.key..."
    P12_KEYSTORE_FILE=$1
    FOLDER=$2
    sudo openssl pkcs12 -in $P12_KEYSTORE_FILE -nodes -nocerts -out $FOLDER/private.key -passin pass:$PW -passout pass:$PW
    echo "Done"
}

extract_crt () {
    echo "Extracting crt files..."
    KEYSTORE_FILE=$1
    FOLDER=$2
    # Extract PEM from P12 File
    sudo openssl pkcs12 -in $KEYSTORE_FILE -passin pass:$PW -passout pass:$PW -nodes -nokeys -out - | awk '/-----BEGIN/{a=1}/-----END/{print;a=0}a' > $FOLDER/output.pem
    # Change Owner of PEM File
    sudo chown bis:bis $FOLDER/output.pem
    # Split PEM into seperate Certificates
    split_pem $FOLDER/output.pem $FOLDER
}

split_pem () {
    sudo awk 'BEGIN {c=0;} /BEGIN CERT/{c++} { print > "'$2/'cert-" c ".pem"}' < $1
}

chain_bundle () {
    INTERMEDIATE_PEM=$1
    ROOT_PEM=$2
    FOLDER=$3
    cat $INTERMEDIATE_PEM $ROOT_PEM > $FOLDER/chain_bundle.pem
}

# Link Certificates for Kibana/ELK
link_elk () {
    echo "Linking elk..."
    FOLDER=$1
    for EXTENSION in ".keystore" ".truststore" ".p12"
    # Extract Keystore
    do
        for FILEPATH in $(find $FOLDER -type f -name "*$EXTENSION")
        do
            if [[ $FILEPATH == *.p12 ]]
            then
                echo "Found P12"
                extract_key $FILEPATH $FOLDER
                extract_crt $FILEPATH $FOLDER
                chain_bundle $FOLDER/cert-2.pem $FOLDER/cert-3.pem $FOLDER
                # Convert extracted Server PEM to CRT
                openssl x509 -outform pem -in $FOLDER/cert-1.pem -out $FOLDER/server-mbis.crt
                # Convert chained bundle PEM to CRT
                openssl x509 -outform pem -in $FOLDER/chain_bundle.pem -out $FOLDER/root-mbis.crt
                # Remove files
                rm -f $FOLDER/cert-1.pem $FOLDER/cert-2.pem $FOLDER/cert-3.pem $FOLDER/chain_bundle.pem $FOLDER/output.pem
                echo "Linking files..."
                sudo ln -sf "$FOLDER/private.key" "$ROOT_ETC/kibana/server.key"
                sudo ln -sf "$FOLDER/server-mbis.crt" "$ROOT_ETC/kibana/server.crt"
                sudo ln -sf "$FOLDER/root-mbis.crt" "$ROOT_ETC/kibana/root.crt"
                echo "Files linked"
            fi
        done
    done
}

link_NextgenAPI () {
    echo "Linking NextgenAPI..."
    FOLDER=$1
    for EXTENSION in ".keystore" ".truststore"
    # Extract Keystore
    do
        for FILEPATH in $(find $FOLDER -type f -name "*$EXTENSION")
        do
            if [  $EXTENSION == ".keystore" ]
            then
                echo "Linking Keystore..."
                sudo ln -sf $FILEPATH "$BIS_HOME/NextGenApi/conf/bisapp.jks"
                echo "$BIS_HOME/NextGenApi/conf/bisapp.jks linked"
            fi
            if [  $EXTENSION == ".truststore" ]
            then
                echo "Linking Truststore..."
                sudo ln -sf $FILEPATH "$BIS_HOME/NextGenApi/conf/nextgen-truststore.jks"
                echo "$BIS_HOME/NextGenApi/conf/nextgen-truststore.jks linked"
            fi
        done
    done
    sudo chown -R bis:bis $BIS_HOME/NextGenApi/conf
    echo "PLEASE ENSURE THE /opt/bis/NextGenApi/conf/application.properties FILE IS UPDATED TO MATCH KEYSTORE PASSWORD AND ALIAS"
}

link_bis2ebis () {
    echo "Linking bis2ebis..."
    FOLDER=$1
    for EXTENSION in ".keystore" ".truststore"
    # Extract Keystore
    do
        for FILEPATH in $(find $FOLDER -type f -name "*$EXTENSION")
        do
            if [  $EXTENSION == ".keystore" ]
            then
                echo "Linking Keystore..."
                sudo ln -sf $FILEPATH "$BIS_HOME/des/etc/bis2ebis/certificates/bisapp.jks"
                echo "$BIS_HOME/des/etc/bis2ebis/certificates/bisapp.jks linked"
            fi
            if [  $EXTENSION == ".truststore" ]
            then
                echo "Linking Truststore..."
                sudo ln -sf $FILEPATH "$BIS_HOME/des/etc/bis2ebis/certificates/des-truststore.jks"
                echo "$BIS_HOME/des/etc/bis2ebis/certificates/des-truststore.jks linked"
            fi
        done
    done
    sudo chown -R bis:bis $BIS_HOME/des/etc/bis2ebis/certificates
    echo "PLEASE ENSURE THE /opt/bis/des/etc/bis2ebis/des-service.xml FILE IS UPDATED TO MATCH KEYSTORE PASSWORD AND ALIAS"
}

for CERT_DIR in "$@"
do
    if [ -d "${CERT_DIR}" ]; then
        echo "${CERT_DIR}"
        BASE_FOLDER=${CERT_DIR##*/}
        if [ $BASE_FOLDER == "wildfly" ]
        then
            link_wildfly $CERT_DIR
        fi
        if [ $BASE_FOLDER == "wms" ]
        then
            link_wms $CERT_DIR
        fi
        if [ $BASE_FOLDER == "keycloak" ]
        then
            link_keycloak $CERT_DIR
        fi
        if [ $BASE_FOLDER == "elk" ]
        then
            link_elk $CERT_DIR
        fi
        if [ $BASE_FOLDER == "bis2ebis" ]
        then
            link_bis2ebis $CERT_DIR
        fi
        if [ $BASE_FOLDER == "NextgenAPI" ]
        then
            link_NextgenAPI $CERT_DIR
        fi
    fi
done