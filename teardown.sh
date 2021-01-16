#!/usr/bin/env sh
set -e

PROJECT_NAME='renameme'
NETWORK_NAME="${PROJECT_NAME}-network"
DATABASE_NAME="${PROJECT_NAME}-database"

echo "Removing ${PROJECT_NAME} image"
docker rmi "$PROJECT_NAME"

echo "Stopping ${DATABASE_NAME}"
docker stop "$DATABASE_NAME"

echo "Removing ${DATABASE_NAME}"
docker rm "$DATABASE_NAME"

echo "Removing ${NETWORK_NAME}"
docker network rm "$NETWORK_NAME"

echo "Removing .gradle, build"
rm -rf .gradle build
