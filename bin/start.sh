#!/usr/bin/env sh

MAIN_IMAGE='renameme'
DATABASE="${MAIN_IMAGE}-database"

NOFORMAT='\033[0m' PURPLE='\033[0;35m'

while [ "$#" -gt 0 ]; do
    case $1 in
    --detach)
        _detach='true'
        ;;
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

[ 'true' = "$_detach" ] && interactive='' || interactive='--interactive'

echo "${PURPLE}Starting '${DATABASE}' container${NOFORMAT}"
docker start "$DATABASE"

echo "${PURPLE}Starting '${MAIN_IMAGE}' container${NOFORMAT}"
# shellcheck disable=SC2086
docker start $interactive "$MAIN_IMAGE"

if [ 'true' != "$_dont_stop_db" ]; then
    echo "${PURPLE}Stopping '${DATABASE}' container${NOFORMAT}"
    docker stop "$DATABASE"
fi
