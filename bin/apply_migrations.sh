#!/usr/bin/env sh

LIQUIBASE_URL='https://github.com/liquibase/liquibase/releases/download/v4.2.2/liquibase-4.2.2.tar.gz'
DRIVER_URL='https://jdbc.postgresql.org/download/postgresql-42.2.18.jar'
DRIVER_PATH='./tmp/db-driver/postgresql.jar'

NOFORMAT='\033[0m' PURPLE='\033[0;35m'

# If `liquibase` command is not available locally, download the Liquibase JAR and use that instead
liquibase='liquibase'
if ! $liquibase --version >/dev/null; then
    liquibase_dir='./tmp/liquibase'
    liquibase_path="${liquibase_dir}/liquibase.jar"
    liquibase_archive="${liquibase_dir}/liquibase.tar.gz"
    echo "${PURPLE}Downloading and extracting Liquibase to ${liquibase_path}${NOFORMAT}"
    mkdir -p "$liquibase_dir"
    curl --silent --location --output "${liquibase_archive}" "$LIQUIBASE_URL"
    tar -C "$liquibase_dir" -zxvf "$liquibase_archive"
    liquibase="java -jar ${liquibase_path}"
fi

if [ ! -f "$DRIVER_PATH" ]; then
    echo "${PURPLE}Downloading database driver to ${DRIVER_PATH}${NOFORMAT}"
    mkdir -p "$(dirname "$DRIVER_PATH")"
    curl --silent --output "${DRIVER_PATH}" "$DRIVER_URL"
fi

# shellcheck disable=SC2086
eval $liquibase \
    --defaultsFile='src/main/resources/liquibase.properties' \
    --classpath="${DRIVER_PATH}" \
    update
