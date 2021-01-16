#!/usr/bin/env sh

PROJECT='renameme'
NETWORK="${PROJECT}-network"
DATABASE="${PROJECT}-database"
TEMP_DIRS='.gradle build'
CACHE_VOLUME='gradle-cache'

NOFORMAT='\033[0m' PURPLE='\033[0;35m'

while [ "$#" -gt 0 ]; do
    case $1 in
    --cache)
        cache='true'
        ;;
    *)
        echo "Unknown option: ${1}"
        exit 1
        ;;
    esac
    shift
done

echo "${PURPLE}Stopping '${PROJECT}' container${NOFORMAT}"
docker container stop "PROJECT"
echo "${PURPLE}Removing '${PROJECT}' container${NOFORMAT}"
docker container rm --volumes "$PROJECT"
echo "${PURPLE}Removing '${PROJECT}' image${NOFORMAT}"
docker image rm "$PROJECT"

echo "${PURPLE}Stopping '${DATABASE}' container${NOFORMAT}"
docker container stop "$DATABASE"
echo "${PURPLE}}Removing '${DATABASE}' container${NOFORMAT}"
docker container rm --volumes "$DATABASE"

echo "${PURPLE}Removing '${NETWORK}' network${NOFORMAT}"
docker network rm "$NETWORK"

for directory in $TEMP_DIRS; do
    echo "${PURPLE}Removing '${directory}'${NOFORMAT}"
    rm -rf "$directory"
done

if [ 'true' = "$cache" ]; then
    echo "${PURPLE}Removing '${CACHE_VOLUME}' volume${NOFORMAT}"
    docker volume rm "$CACHE_VOLUME"
fi
