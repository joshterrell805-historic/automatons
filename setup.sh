log4japi="$(readlink -e /usr/share/java/log4j-api.jar)"
log4jcore="$(readlink -e /usr/share/java/log4j-core.jar)"
classpath="$CLASSPATH:$log4japi:$log4jcore"
export CLASSPATH="$classpath"
if [ -n "$1" ]
then
    "$@"
else
    $SHELL
fi
