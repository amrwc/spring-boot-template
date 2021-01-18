#!/usr/bin/env sh

PROJECT='renameme'
NETWORK="${PROJECT}-network"
DATABASE="${PROJECT}-database"
TEMP_DIRS='.gradle build'
CACHE_VOLUME='gradle-cache'

NOFORMAT='\033[0m' PURPLE='\033[0;35m'

while [ "$#" -gt 0 ]; do
    case $1 in
    --exclude-db)
        _exclude_db='true'
        ;;
    --include-cache)
        _include_cache='true'
        ;;
    *)
        echo "Unknown option: ${1}"
        exit 1
        ;;
    esac
    shift
done

echo "${PURPLE}Stopping '${PROJECT}' container${NOFORMAT}"
docker container stop "$PROJECT"
echo "${PURPLE}Removing '${PROJECT}' container${NOFORMAT}"
docker container rm --volumes "$PROJECT"
echo "${PURPLE}Removing '${PROJECT}' image${NOFORMAT}"
docker image rm "$PROJECT"

echo "${PURPLE}Stopping '${DATABASE}' container${NOFORMAT}"
docker container stop "$DATABASE"
if [ 'true' != "$_exclude_db" ]; then
    echo "${PURPLE}Removing '${DATABASE}' container${NOFORMAT}"
    docker container rm --volumes "$DATABASE"
fi

echo "${PURPLE}Removing '${NETWORK}' network${NOFORMAT}"
docker network rm "$NETWORK"

if [ 'true' = "$_include_cache" ]; then
    echo "${PURPLE}Removing '${CACHE_VOLUME}' volume${NOFORMAT}"
    docker volume rm "$CACHE_VOLUME"
fi

for directory in $TEMP_DIRS; do
    echo "${PURPLE}Removing '${directory}'${NOFORMAT}"
    rm -rf "$directory"
done
