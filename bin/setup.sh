#!/usr/bin/env sh

CACHE_VOLUME='gradle-cache'
PROJECT='renameme'
NETWORK="${PROJECT}-network"
DATABASE="${PROJECT}-database"
DATABASE_IMAGE="postgres:latest"

NOFORMAT='\033[0m' PURPLE='\033[0;35m'

while [ "$#" -gt 0 ]; do
    case $1 in
    --debug)
        _debug='debug=true'
        ;;
    --no-cache)
        _no_cache='--no-cache'
        ;;
    --suspend)
        _suspend='suspend=true'
        ;;
    *)
        echo "Unknown option: ${1}"
        exit 1
        ;;
    esac
    shift
done

build_args="${_debug} ${_suspend}"
# shellcheck disable=SC2086,SC2116
build_args="$(echo $build_args)" # Trim white space
if [ -n "$build_args" ]; then
    builder=''
    for arg in $build_args; do
        builder="${builder} --build-arg ${arg}"
    done
    _build_args="$builder"
fi

if [ 'debug=true' = "$_debug" ] || [ 'suspend=true' = "$_suspend" ]; then
    _debug_port='--publish 8000:8000'
fi

echo "${PURPLE}Creating '${CACHE_VOLUME}' volume${NOFORMAT}"
docker volume create --name "$CACHE_VOLUME"

echo "${PURPLE}Building '${PROJECT}' image${NOFORMAT}"
# shellcheck disable=SC2086
docker build $_no_cache --tag "${PROJECT}:latest" --file docker/Dockerfile $_build_args .

echo "${PURPLE}Creating '${NETWORK}' network${NOFORMAT}"
docker network create --driver bridge "$NETWORK"

echo "${PURPLE}Creating '${DATABASE_IMAGE}' container${NOFORMAT}"
docker create \
    --publish 5432:5432 \
    --network="$NETWORK" \
    --env-file docker/postgres-envars.list \
    --name "$DATABASE" \
    "$DATABASE_IMAGE"

echo "${PURPLE}Creating '${PROJECT}' container${NOFORMAT}"
# shellcheck disable=SC2086
docker create --interactive --tty \
    $_debug_port \
    --publish 8080:8080 \
    --network="$NETWORK" \
    --name "$PROJECT" \
    "$PROJECT"
