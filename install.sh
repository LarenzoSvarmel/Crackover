#!/usr/bin/env bash
CO_PWD=~/Applications/CrossOver.app/Contents/MacOS
test -d "${CO_PWD}" || CO_PWD=/Applications/CrossOver.app/Contents/MacOS

test -d "${CO_PWD}" || (echo 'unable to detect app path. exiting...' && exit)

PWD="${CO_PWD}"
cd "${PWD}"

PROC_NAME='CrossOver'
pids=(`pgrep "${PROC_NAME}"`, `pidof "${PROC_NAME}"`, `ps -Ac | grep -m1 "${PROC_NAME}" | awk '{print $1}'`)
pids=`echo ${pids[*]}|tr ',' ' '`

[ "${pids}" ] && kill -9 `echo "${pids}"` > /dev/null 2>&1

FIX_FILE_LINK="https://gist.githubusercontent.com/ellsies/e9383c75fd8cd8d5781dac91d7e2360d/raw/d4431abd07cdcd83853567b646d0b68bf66c7e6c/Crossover.sh"

if [ -f CrossOver.origin ]; then
  echo 'already installed. update and exit.'
  echo "$(curl -fsSL ${FIX_FILE_LINK})" > CrossOver
  exit
fi;

test -f CrossOver.origin || mv CrossOver CrossOver.origin

echo "$(curl -fsSL ${FIX_FILE_LINK})" > CrossOver

chmod +x CrossOver

echo 'Done. Please open CrossOver '
