#!/bin/sh
#
# Create bis-keycloak-credentials.jceks with database password.
#
# Prompt for database password.
# Create the password protected bis-keycloak-credentials.jceks file.
# Add appropriate database password.
# Create a mask of the bis-keycloak-credentials.jceks file password and add it to mbiskeycloak.xml.
#
. /etc/sysconfig/MORPHO_BIS

if [ "`whoami`" != "$BIS_OWNER" ]
then
        sudo -u bis `readlink -f $0` $*
        exit 0
fi

# Set DEBUG if elytron-tool.sh fails.
DEBUG=
#DEBUG=--debug

# Used when saving existing credential store and mbiskeycloak.xml files.
BACKUP_DATE=`date '+%Y-%m-%d_%H-%M-%S'`

BIS_KEYCLOAK_CREDENTIALS_FILE=$BIS_HOME/keycloak/standalone/configuration/bis-keycloak-credentials.jceks


#
# Define get_password function.  Prompt for password
# and confirmation.  Exit if data does not match.
#
# $1 - prompt
# $2 - dest
#
function get_password {
        _PROMPT="$1"
	echo -n "Please enter ${_PROMPT} password: "
	read -s "$2"
	echo
        _PW="${!2}"

#	echo -n "Confirm ${_PROMPT} password: "
#	read -s _CONFIRM_PW
#	echo
#
#	if [ "${_PW}" != "${_CONFIRM_PW}" ] ; then
#		echo "Passwords do not match.  Aborting."
#		exit -1
#	fi
}


#
# Prompt for passwords.
#
get_password "credential store" BIS_KEYCLOAK_CREDENTIALS_PW
get_password "database" DATABASE_PW
get_password "keystore" WILDFLY_KEYSTOPRE_PW

#
# Create the credential store.
#
if [ -f "${BIS_KEYCLOAK_CREDENTIALS_FILE}" ] ; then
	echo "Found existing ${BIS_KEYCLOAK_CREDENTIALS_FILE} file.  Moving it to ${BIS_KEYCLOAK_CREDENTIALS_FILE}.${BACKUP_DATE}"
	mv ${BIS_KEYCLOAK_CREDENTIALS_FILE} ${BIS_KEYCLOAK_CREDENTIALS_FILE}.${BACKUP_DATE}
fi

~/keycloak/bin/elytron-tool.sh credential-store ${DEBUG} --location ${BIS_KEYCLOAK_CREDENTIALS_FILE} --create --password "${BIS_KEYCLOAK_CREDENTIALS_PW}"

#MBISP-23787: Add property so the logger is set and won't print an error
export JAVA_OPTS="-Djava.util.logging.manager=org.jboss.logmanager.LogManager"

#
# Add the database passwords to the credential store.
#
for CRED in keycloak-db-pw ; do
	~/keycloak/bin/elytron-tool.sh credential-store ${DEBUG} --location ${BIS_KEYCLOAK_CREDENTIALS_FILE} --password "${BIS_KEYCLOAK_CREDENTIALS_PW}" --add "${CRED}" --secret "${DATABASE_PW}"
done

#
# Add the keystore passwords to the credential store

~/keycloak/bin/elytron-tool.sh credential-store ${DEBUG} --location ${BIS_KEYCLOAK_CREDENTIALS_FILE} --password "${BIS_KEYCLOAK_CREDENTIALS_PW}" --add "wildfly-keystore-pw" --secret "${WILDFLY_KEYSTOPRE_PW}"

#
# Display the contents of the credential store.
#
~/keycloak/bin/elytron-tool.sh credential-store ${DEBUG} --location "${BIS_KEYCLOAK_CREDENTIALS_FILE}" --password "${BIS_KEYCLOAK_CREDENTIALS_PW}" --aliases


#
# Obfuscate the credential store password then store the obfuscated password in mbiskeystore.xml.
#
_SALT=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8`
_ITERATION=`shuf -i 500-999 -n 1`
MASK=`~/keycloak/bin/elytron-tool.sh mask ${DEBUG} --salt "${_SALT}" --iteration "${_ITERATION}" --secret "${BIS_KEYCLOAK_CREDENTIALS_PW}"`

MBISKEYCLOAK_XML=$BIS_HOME/keycloak/standalone/configuration/mbiskeycloak.xml
if [ -f "${MBISKEYCLOAK_XML}" ] ; then
	echo "Found existing ${MBISKEYCLOAK_XML} file.  Saving it to ${MBISKEYCLOAK_XML}.${BACKUP_DATE}"
	cp ${MBISKEYCLOAK_XML} ${MBISKEYCLOAK_XML}.${BACKUP_DATE}
fi

# Use pipe delimiter since MASK can contain slashes and dots.
sed "s|credential-reference clear-text=\"MASK.*|credential-reference clear-text=\"${MASK}\"/>|" -i "${MBISKEYCLOAK_XML}"
echo "Updated credential reference in ${MBISKEYCLOAK_XML}."
