#!/bin/bash

set -e

TIMEOUT=120
COUNT=0
IP=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
PORT=${2:-"8021"}

until ((echo >/dev/tcp/$IP/$PORT) &>/dev/null && true || false) || [ $COUNT -eq $TIMEOUT ];
do
  echo "Try #${COUNT} - Timeout ${TIMEOUT}s"
  sleep 1
  COUNT=$((COUNT+1))    
done