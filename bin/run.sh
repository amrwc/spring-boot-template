#!/usr/bin/env sh

MAIN_IMAGE='renameme'
MAIN_CONTAINER="$MAIN_IMAGE"
SPRING_PORT='8080'
DEBUG_PORT='8000'

CACHE_VOLUME='gradle-build-cache'
NETWORK="${MAIN_IMAGE}-network"

BUILD_IMAGE="${MAIN_IMAGE}-gradle-build"
BUILD_CONTAINER="$BUILD_IMAGE"
BUILD_COMMAND='gradle build --stacktrace --exclude-task test'

DATABASE_IMAGE='postgres:latest'
DATABASE_CONTAINER="${MAIN_IMAGE}-database"
DATABASE_PORT='5432'

log() {
    COLOUR_RESET='\033[0m'
    PURPLE_BOLD='\033[1;35m'
    echo "${PURPLE_BOLD}==> ${1} <==${COLOUR_RESET}"
}

while [ "$#" -gt 0 ]; do
    case $1 in
    --apply-migrations)
        _apply_migrations='true'
        ;;
    --debug)
        _debug='debug=true'
        ;;
    --detach)
        _detach='true'
        ;;
    --suspend)
        _suspend='suspend=true'
        ;;
    *)
        echo "Unknown option: '${1}'"
        exit 1
        ;;
    esac
    shift
done

##############################################################################
##################### Prepare miscellaneous Docker items #####################
##############################################################################
log "Creating '${CACHE_VOLUME}' volume"
docker volume create --name "$CACHE_VOLUME"

log "Creating '${MAIN_IMAGE}' network"
docker network create --driver bridge "$NETWORK"

##############################################################################
########################## Build and export the JAR ##########################
##############################################################################
log "Building '${BUILD_IMAGE}' image"
docker build --tag "$BUILD_IMAGE" --file ./docker/Dockerfile-gradle .

log "Running '${BUILD_IMAGE}' image"
# shellcheck disable=SC2086
docker run --interactive --tty \
    --name "$BUILD_CONTAINER" \
    --volume "${CACHE_VOLUME}:/home/gradle/.gradle" \
    --user gradle \
    "$BUILD_IMAGE" \
    $BUILD_COMMAND

log "Copying JAR from '${BUILD_CONTAINER}'"
rm -r ./build/libs >/dev/null 2>&1
mkdir -p ./build/libs
docker cp "${BUILD_CONTAINER}:/home/gradle/project/build/libs" ./build
mv ./build/libs/*.jar ./build/libs/app.jar

##############################################################################
############### Build the main image and create the container ################
##############################################################################
log "Building '${MAIN_IMAGE}' image"
docker build --tag "$MAIN_IMAGE" --file ./docker/Dockerfile-main .

log "Creating '${MAIN_CONTAINER}' container"
publish_main="--publish ${SPRING_PORT}:${SPRING_PORT}"
if [ 'debug=true' = "$_debug" ] || [ 'suspend=true' = "$_suspend" ]; then
    publish_main="${publish_main} --publish ${DEBUG_PORT}:${DEBUG_PORT}"
fi
# shellcheck disable=SC2086
docker create --interactive --tty \
    $publish_main \
    --name "$MAIN_CONTAINER" \
    --network="$NETWORK" \
    "$MAIN_IMAGE"

log "Copying JAR into '${MAIN_CONTAINER}'"
docker cp ./build/libs/app.jar "${MAIN_CONTAINER}:/home/project/app.jar"

##############################################################################
########################## Run the database image ############################
##############################################################################
log "Running '${DATABASE_IMAGE}' container, name: ${DATABASE_CONTAINER}"
docker run --detach \
    --name "$DATABASE_CONTAINER" \
    --publish "${DATABASE_PORT}:${DATABASE_PORT}" \
    --network="$NETWORK" \
    --env-file ./docker/postgres-envars.list \
    "$DATABASE_IMAGE"

if [ 'true' = "$_apply_migrations" ]; then
    log 'Applying database migrations'
    sleep 3 # Wait for the database to come up
    ./bin/apply_migrations.sh
fi

##############################################################################
############################ Start the main image ############################
##############################################################################
log "Starting '${MAIN_CONTAINER}'"
attach_interactive='--attach --interactive'
if [ 'true' = "$_detach" ]; then
    attach_interactive=''
fi
# shellcheck disable=SC2086
docker start $attach_interactive "$MAIN_CONTAINER"

##############################################################################
################### Teardown the build container and image ###################
##############################################################################
log "Stopping '${BUILD_CONTAINER}' container"
docker container stop "$BUILD_CONTAINER"
log "Removing '${BUILD_CONTAINER}' container"
docker container rm "$BUILD_CONTAINER"
log "Removing '${BUILD_IMAGE}' image"
docker image rm "$BUILD_IMAGE"
