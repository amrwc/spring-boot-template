#!/usr/bin/env sh

get_debug_option() {
    # shellcheck disable=SC2153
    [ 'true' = "$SUSPEND" ] && suspend='y' || suspend='n'
    echo "-agentlib:jdwp=transport=dt_socket,server=y,suspend=${suspend},address=*:8000"
}

if [ 'true' = "$DEBUG" ] || [ 'true' = "$SUSPEND" ]; then
    _debug_arg="$(get_debug_option)"
fi

# shellcheck disable=SC2086
java $_debug_arg -jar app.jar
