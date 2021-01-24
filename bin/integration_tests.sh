#!/usr/bin/env sh

MAIN_IMAGE='renameme'
DATABASE="${MAIN_IMAGE}-test-database"
DATABASE_IMAGE='postgres:latest'

DATABASE_PORT='5432'

NOFORMAT='\033[0m' PURPLE='\033[0;35m'

echo "${PURPLE}Creating '${DATABASE_IMAGE}' container, name: ${DATABASE}${NOFORMAT}"
docker run --detach \
    --publish "${DATABASE_PORT}:${DATABASE_PORT}" \
    --env-file ./docker/postgres-envars.list \
    --name "$DATABASE" \
    "$DATABASE_IMAGE"

echo "${PURPLE}Applying database migrations${NOFORMAT}"
./bin/apply_migrations.sh

echo "${PURPLE}Running integration tests${NOFORMAT}"
./gradlew integrationTest

echo "${PURPLE}Stopping '${DATABASE}' container${NOFORMAT}"
docker stop "$DATABASE"

echo "${PURPLE}Removing '${DATABASE}' container${NOFORMAT}"
docker container rm --volumes "$DATABASE"
