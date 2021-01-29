#!/usr/bin/env sh

MAIN_IMAGE_TAG='renameme'
MAIN_CONTAINER_NAME="$MAIN_IMAGE_TAG"
DATABASE_CONTAINER_NAME="${MAIN_IMAGE_TAG}-database"

NETWORK_NAME="${MAIN_IMAGE_TAG}-network"
CACHE_VOLUME='gradle-build-cache'
TEMP_DIRECTORIES='.gradle build tmp'

log() {
    COLOUR_RESET='\033[0m'
    PURPLE_BOLD='\033[1;35m'
    echo "${PURPLE_BOLD}==> ${1} <==${COLOUR_RESET}"
}

while [ "$#" -gt 0 ]; do
    case $1 in
    --include-cache)
        _include_cache='true'
        ;;
    --include-db)
        _include_db='true'
        ;;
    *)
        echo "Unknown option: '${1}'"
        exit 1
        ;;
    esac
    shift
done

log "Stopping '${MAIN_CONTAINER_NAME}' container"
docker container stop "$MAIN_CONTAINER_NAME"
log "Removing '${MAIN_CONTAINER_NAME}' container"
docker container rm --volumes "$MAIN_CONTAINER_NAME"
log "Removing '${MAIN_IMAGE_TAG}' image"
docker image rm "$MAIN_IMAGE_TAG"

if [ 'true' = "$_include_db" ]; then
    log "Stopping '${DATABASE_CONTAINER_NAME}' container"
    docker container stop "$DATABASE_CONTAINER_NAME"
    log "Removing '${DATABASE_CONTAINER_NAME}' container"
    docker container rm --volumes "$DATABASE_CONTAINER_NAME"
fi

# Since nothing exists within the network at this point, remove it
if [ 'true' = "$_include_db" ]; then
    log "Removing '${NETWORK_NAME}' network"
    docker network rm "$NETWORK_NAME"
fi

if [ 'true' = "$_include_cache" ]; then
    log "Removing '${CACHE_VOLUME}' volume"
    docker volume rm "$CACHE_VOLUME"
fi

for directory in $TEMP_DIRECTORIES; do
    log "Removing '${directory}' temp directory"
    rm -rf "$directory"
done
