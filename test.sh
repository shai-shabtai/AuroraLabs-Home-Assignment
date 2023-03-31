#!/usr/bin/env bash

set -x

# Check if docker test is running 
output=$(docker ps | grep py-app-check)
if [[ $output == '' ]]; then
    echo "ERROR: docker check is not running $output"
    exit 1
fi

# Test `/healthcheck` call -- should return 
output=$(docker exec py-app-check bash -c 'curl \
    --write-out "%{http_code}" \
    --silent \
    --output /dev/null \
    http://localhost:5000/healthcheck')
if [[ $output != '200' ]]; then
    echo "ERROR: healthcheck request failed with response code $output"
    exit 1
fi

# Add an api `/healthcheck` which will always return {"status":"ok"}
output=$(docker exec py-app-check bash -c 'curl \
    --fail \
    --silent \
    http://localhost:5000/healthcheck')
if [[ $output != '{"status":"ok"}' ]]; then
    echo "ERROR: healthcheck request got unexpected output: $output"
    exit 1
fi

# Test to check the /get reesponse
output=$(docker exec py-app-check bash -c 'curl \
    --fail \
    --silent \
    http://localhost:5000/get')
if [[ $output != 'Devops is great' ]]; then
    echo "ERROR: countcheck request got unexpected output: $output"
    exit 1
fi

echo "TEST COMPLETED SUCCESSFULLY"