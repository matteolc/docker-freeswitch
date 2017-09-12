#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
IP=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
SERVICE=freeswitch
FS_CLI_SECRET=demo

function fs_cli_command() {
  docker exec ${SERVICE} fs_cli -H $IP -p $FS_CLI_SECRET -x "$*"
}

function module_exists {
  fs_cli_command module_exists "$*"
}

echo "---------------------------------------------------------------------"
echo "Waiting until ${SERVICE} is up"
echo "---------------------------------------------------------------------"
$DIR/wait-for-${SERVICE}.sh
echo "---------------------------------------------------------------------"
echo "User running ${SERVICE}"
echo "---------------------------------------------------------------------"
docker exec ${SERVICE} ps ax --format 'user:10 pid command' | grep ${SERVICE}
echo "---------------------------------------------------------------------"
echo "${SERVICE} status"
echo "---------------------------------------------------------------------"
fs_cli_command show status
echo "---------------------------------------------------------------------"
echo "${SERVICE} CODECS"
echo "---------------------------------------------------------------------"
fs_cli_command show codecs
echo "---------------------------------------------------------------------"
echo "${SERVICE} SIP status"
echo "---------------------------------------------------------------------"
fs_cli_command sofia status

module_exists mod_bcg729
module_exists mod_nibblebill
module_exists mod_lua