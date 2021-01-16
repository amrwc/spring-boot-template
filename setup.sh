#!/usr/bin/env sh
set -e

PROJECT_NAME='renameme'
NETWORK_NAME="${PROJECT_NAME}-network"
DATABASE_NAME="${PROJECT_NAME}-database"

echo "Compiling ${PROJECT_NAME}"
docker run --rm \
    -u gradle \
    -v "${PWD}:/home/gradle/project" \
    -w /home/gradle/project \
    gradle:jdk11 \
    gradle build -x test

echo "Building ${PROJECT_NAME}"
docker build -t "${PROJECT_NAME}:latest" -f .docker/Dockerfile .

echo "Creating ${NETWORK_NAME}"
docker network create -d bridge "$NETWORK_NAME"

echo "Running postgres:latest"
docker run -d \
    -p 5432:5432 \
    --network="$NETWORK_NAME" \
    --env-file .docker/postgres-envars.list \
    --name "$DATABASE_NAME" \
    postgres:latest

echo "Running ${PROJECT_NAME}"
docker run -it \
    --rm \
    -p 8080:8080 \
    --network="$NETWORK_NAME" \
    "$PROJECT_NAME"
