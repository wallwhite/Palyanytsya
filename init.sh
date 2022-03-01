#!/bin/bash 

while getopts c:a: flag
do
    case "${flag}" in
        c) code=${OPTARG};;
        a) alias=${OPTARG};;
    esac
done

FILE_DIST=./.env.example
if test -f "$FILE_DIST"; then
  rm -rf ./.env
  
  cp ./.env.example ./.env

 printf '\nCODE="'$code'"\n' >> ./.env
 printf 'SERVER="'$alias'"\n' >> ./.env
fi
