#!/usr/bin/env sh

PROJECT_NAME='renameme'
NETWORK_NAME="${PROJECT_NAME}-network"
DATABASE_NAME="${PROJECT_NAME}-database"

echo "Removing ${PROJECT_NAME} image"
docker image rm "$PROJECT_NAME"

echo "Stopping ${DATABASE_NAME}"
docker container stop "$DATABASE_NAME"

echo "Removing ${DATABASE_NAME}"
docker container rm --volumes "$DATABASE_NAME"

echo "Removing ${NETWORK_NAME}"
docker network rm "$NETWORK_NAME"

echo "Removing .gradle, build"
rm -rf .gradle build
