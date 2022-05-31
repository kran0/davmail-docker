#!/bin/bash -ex

#
# This file is not the entrypoint itself!
#
# Unfortunately davmail.Settings is not supporting environment-based
# configuration: https://sourceforge.net/p/davmail/code/HEAD/tree/trunk/src/java/davmail/Settings.java
#
# This script implements envirenment support entrypoint generation
# based on the original davmail.properties file: https://sourceforge.net/p/davmail/code/HEAD/tree/trunk/src/etc/davmail.properties

DAVMAIL_PROPERTIES_FILE="${1:-./davmail.properties.example}"

function getPropertyValues {
 # Remove comments and empty lines
 sed -e '/^[[:space:]]*#.*$/d;/^[[:space:]]*$/d' "${@}"
}

function convertOptionToBashFomat {
 # Convert Option.Name.format to BASH_REGULAR_FROMAT
 [ -z "${@}" ] || (
  RET="${@^^}"       #to uppercase
  RET="${RET//[.]/_}" #replace [.] matched characters to _
  echo "${RET}"
 )
}

function genTemplate {
 getPropertyValues "${@}"\
  | while read line
    do
     (
      OPTION="$(cut -f1 -d= <<< ${line})"
      VALUES="$(sed -e "s/^.*=//" <<< ${line})"
      OPTION_BASH=$(convertOptionToBashFomat "${OPTION}")
      [ -z "${VALUES}" ]\
       && echo ${OPTION}='${'${OPTION_BASH}'}'\
       || echo ${OPTION}='${'${OPTION_BASH}':-'${VALUES}'}'
     )
    done
}

# MAIN
cat << ENTRYPOINT
#!/bin/ash -e

#
# This file is auto-generated $(date) with ${0} ${@}
#
# Davmail-container entrypoint file:
#   Adds environment-based configuration for DavMail
#   Allows passing old-fasion text-based configurations
#   Respecting external set JAVA_OPTS
#
# Is compatible with our prebuilt image:
#   Force using openjdk-jre
#   Force DavMail server and notray mode operation
#   Use ash for compatibility with BusyBox
#
# Based on the guides from the main DavMail project:
#  Main:
#    http://davmail.sourceforge.net/serversetup.html
#    https://sourceforge.net/p/davmail/code/HEAD/tree/trunk/src/java/davmail/Settings.java
#  Options -notray and -server:
#    http://davmail.sourceforge.net/linuxsetup.html
#    https://sourceforge.net/p/davmail/code/HEAD/tree/trunk/src/java/davmail/DavGateway.java
#  Java exec and JAVA_OPTS:
#    https://sourceforge.net/p/davmail/code/HEAD/tree/trunk/src/bin/davmail

# Usage: $0 [DAVMAIL_PROPERTIES_FILE]
# Usage: $0 [witout args]

if [ -z "\${1}" ]
then
 readonly DAVMAIL_PROPERTIES_FILE="\$(mktemp)"
 (umask 0077
  cat << FILL_TEMPLATE_WITH_ENV
$(genTemplate "${DAVMAIL_PROPERTIES_FILE}")
FILL_TEMPLATE_WITH_ENV
 ) > "\${DAVMAIL_PROPERTIES_FILE}"
else
 readonly DAVMAIL_PROPERTIES_FILE="\${1}"
fi

JAVA_OPTS="\${JAVA_OPTS:--Xmx512M -Dsun.net.inetaddr.ttl=60}"

exec java \${JAVA_OPTS}\\
          -cp '/davmail/davmail.jar:/davmail/lib/*'\\
          'davmail.DavGateway' -notray -server "\${DAVMAIL_PROPERTIES_FILE}"
ENTRYPOINT
