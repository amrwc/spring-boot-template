#!/usr/bin/env sh

CACHE_VOLUME='gradle-cache'
PROJECT='renameme'
NETWORK="${PROJECT}-network"
DATABASE="${PROJECT}-database"
DATABASE_IMAGE="postgres:latest"

NOFORMAT='\033[0m' PURPLE='\033[0;35m'

echo "${PURPLE}Creating '${CACHE_VOLUME}' volume${NOFORMAT}"
docker volume create --name "$CACHE_VOLUME"

echo "${PURPLE}Building '${PROJECT}' image${NOFORMAT}"
docker build --tag "${PROJECT}:latest" --file .docker/Dockerfile .

echo "${PURPLE}Creating '${NETWORK}' network${NOFORMAT}"
docker network create --driver bridge "$NETWORK"

echo "${PURPLE}Running '${DATABASE_IMAGE}' image${NOFORMAT}"
docker run --detach \
    --publish 5432:5432 \
    --network="$NETWORK" \
    --env-file .docker/postgres-envars.list \
    --name "$DATABASE" \
    "$DATABASE_IMAGE"

echo "${PURPLE}Running '${PROJECT}' image${NOFORMAT}"
docker run --interactive --tty \
    --publish 8080:8080 \
    --network="$NETWORK" \
    --name "$PROJECT" \
    "$PROJECT"

echo "${PURPLE}Stopping '${DATABASE}' container${NOFORMAT}"
docker stop "$DATABASE"
