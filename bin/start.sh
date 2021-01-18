#!/usr/bin/env sh

PROJECT='renameme'
DATABASE="${PROJECT}-database"

NOFORMAT='\033[0m' PURPLE='\033[0;35m'

while [ "$#" -gt 0 ]; do
    case $1 in
    --dont-stop-db)
        _dont_stop_db='true'
        ;;
    *)
        echo "Unknown option: ${1}"
        exit 1
        ;;
    esac
    shift
done

echo "${PURPLE}Starting '${DATABASE}' container${NOFORMAT}"
docker start "$DATABASE"

echo "${PURPLE}Starting '${PROJECT}' container${NOFORMAT}"
docker start --interactive "$PROJECT"

if [ 'true' != "$_dont_stop_db" ]; then
    echo "${PURPLE}Stopping '${DATABASE}' container${NOFORMAT}"
    docker stop "$DATABASE"
fi
