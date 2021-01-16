#!/usr/bin/env sh

PROJECT='renameme'
DATABASE="${PROJECT}-database"

NOFORMAT='\033[0m' PURPLE='\033[0;35m'

while [ "$#" -gt 0 ]; do
    case $1 in
    --rebuild)
        rebuild='true'
        ;;
    *)
        echo "Unknown option: ${1}"
        exit 1
        ;;
    esac
    shift
done

if [ 'true' = "$rebuild" ]; then
    echo "${PURPLE}Building '${PROJECT}' image${NOFORMAT}"
    docker build --tag "${PROJECT}:latest" --file .docker/Dockerfile .
fi

echo "${PURPLE}Running '${DATABASE}' container${NOFORMAT}"
docker start "$DATABASE"

echo "${PURPLE}Running '${PROJECT}' container${NOFORMAT}"
docker start --interactive "$PROJECT"

echo "${PURPLE}Stopping '${DATABASE}' container${NOFORMAT}"
docker stop "$DATABASE"
