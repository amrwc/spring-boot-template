#!/usr/bin/env sh

URLS='http://localhost:8080/actuator/info http://localhost:8080/api/welcome/1'

for url in $URLS; do
    response_code="$(curl --silent --show-error --write-out '%{http_code}' "$url")"
    if [ 200 -ne "$response_code" ]; then
      echo "::error::Expected 200 response code but received ${response_code} from ${url}"
      failed='true'
    fi
done

if [ 'true' = "$failed" ]; then
    echo "::error::One or more endpoints returned an unexpected result."
    exit 1
fi
