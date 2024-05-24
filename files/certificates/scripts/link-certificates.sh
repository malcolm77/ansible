#!/bin/sh

# DESCRIPTION
# Script to link all relevant keystore, truststore and .p12 files in MBIS

function usage {
    echo ""
    echo "******************** Usage *************************"
    echo "Ensure bisapp.jks and truststore.jks file are present in the opt/certificates/MBIS folder"
    echo "Ensure bisapp.jks and truststore.jks file are present in the opt/certificates/DES folder"
    echo "Ensure bisapp.p12 is present in the opt/certificates/ELK folder"
    echo "$0 wildfly keycloak wms elk des"
    echo "Only pass in services you want to deploy"
    echo "ELK requires sudo"
    echo "****************************************************"

    exit 1
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
CERT_DIR="/opt/certificates"

link_mbis () {
     echo "**** Linking MBIS Certificates ****"

    ln -sf "$CERT_DIR/MBIS/bisapp.jks" "$BIS_ETC/server.keystore"
    echo "$BIS_ETC/server.keystore linked"

    ln -sf "$CERT_DIR/MBIS/bisapp.jks" "$BIS_ETC/client.keystore"
    echo "$BIS_ETC/client.keystore linked"

    ln -sf "$CERT_DIR/MBIS/truststore.jks" "$BIS_ETC/client.truststore"
    echo "$BIS_ETC/client.truststore linked"

    ln -sf "$CERT_DIR/MBIS/truststore.jks" "$BIS_ETC/server.default.truststore"
    echo "$BIS_ETC/server.default.truststore linked"
}

link_wildfly () {
     echo "**** Linking WILDFLY Certificates ****"

    ln -sf "$CERT_DIR/MBIS/bisapp.jks" "$WILDFLY_DIR/wildfly.keystore"
    echo "$WILDFLY_DIR/wildfly.keystore linked"

    ln -sf "$CERT_DIR/MBIS/truststore.jks" "$WILDFLY_DIR/wildfly.truststore"
    echo "$WILDFLY_DIR/wildfly.truststore linked"
}

link_wms () {
    echo "**** Linking WMS Certificates ****"

    ln -sf "$CERT_DIR/MBIS/bisapp.jks" "$WMS_DIR/wms.keystore"
    echo "$WMS_DIR/wms.keystore linked"

    ln -sf "$CERT_DIR/MBIS/truststore.jks" "$WMS_DIR/wms.truststore"
    echo "$WMS_DIR/wms.truststore linked"
}

link_keycloak () {
    echo "**** Linking KEYCLOAK Certificates ****"

    ln -sf "$CERT_DIR/MBIS/bisapp.jks" "$KEYCLOAK_DIR/mbiskeycloak.keystore"
    echo "$KEYCLOAK_DIR/mbiskeycloak.keystore linked"

    ln -sf "$CERT_DIR/MBIS/truststore.jks" "$KEYCLOAK_DIR/mbiskeycloak-client.truststore"
    echo "$KEYCLOAK_DIR/mbiskeycloak-client.truststore linked"
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
    echo "**** Linking ELK Certificates ****"
    FOLDER="$CERT_DIR/ELK"
    extract_key "$CERT_DIR/ELK/bisapp.p12" $FOLDER
    extract_crt "$CERT_DIR/ELK/bisapp.p12" $FOLDER
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
}

link_Des () {
    echo "**** Linking DES Certificates ****"

    sudo ln -sf "$CERT_DIR/DES/bisapp.jks" "$BIS_HOME/des/etc/bis2ebis/certificates/bisapp.jks"
    echo "$BIS_HOME/des/etc/bis2ebis/certificates/bisapp.jks linked"

    sudo ln -sf  "$CERT_DIR/DES/truststore.jks" "$BIS_HOME/des/etc/bis2ebis/certificates/des-truststore.jks"
    echo "$BIS_HOME/des/etc/bis2ebis/certificates/des-truststore.jks linked"

    sudo ln -sf  "$CERT_DIR/DES/bisapp.jks" "$BIS_HOME/NextGenApi/conf/bisapp.jks"
    echo "$BIS_HOME/NextGenApi/conf/bisapp.jks linked"

    sudo ln -sf  "$CERT_DIR/DES/truststore.jks" "$BIS_HOME/NextGenApi/conf/nextgen-truststore.jks"
    echo "$BIS_HOME/NextGenApi/conf/nextgen-truststore.jks linked"

    sudo chown -R bis:bis $BIS_HOME/NextGenApi/conf
    sudo chown -R bis:bis $BIS_HOME/des/etc/bis2ebis/certificates
    echo "PLEASE ENSURE THE /opt/bis/NextGenApi/conf/application.properties FILE IS UPDATED TO MATCH KEYSTORE PASSWORD AND ALIAS"
    echo "PLEASE ENSURE THE /opt/bis/des/etc/bis2ebis/des-service.xml FILE IS UPDATED TO MATCH KEYSTORE PASSWORD AND ALIAS"
}

# link_mbis should run on every machine
link_mbis

for SVC_NAME in "$@"
do
    if [ $SVC_NAME == "wildfly" ]
    then
        link_wildfly
    fi
    if [ $SVC_NAME == "wms" ]
    then
        link_wms
    fi
    if [ $SVC_NAME == "keycloak" ]
    then
        link_keycloak
    fi
    if [ $SVC_NAME == "elk" ]
    then
        link_elk
    fi
    if [ $SVC_NAME == "des" ]
    then
        link_Des
    fi
done