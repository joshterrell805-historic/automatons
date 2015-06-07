classpath="$CLASSPATH"
export CLASSPATH="$classpath"
if [ -n "$1" ]
then
    "$@"
else
    $SHELL
fi
