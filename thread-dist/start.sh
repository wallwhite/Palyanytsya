#!/usr/bin/env bash

while getopts q:s:r:c: flag
do
    case "${flag}" in
        s) server=${OPTARG};;
        r) requests_count=${OPTARG};;
        c) connections_count=${OPTARG};;
    esac
done

apk add --update curl && \
    rm -rf /var/cache/apk/*

apk add --update mc && \
    rm -rf /var/cache/apk/*

curl ifconfig.io/country_code

go install github.com/codesenberg/bombardier@latest

echo "Starting flood"

bombardier -c $connections_count -n $requests_count $server
