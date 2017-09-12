#!/bin/bash

# Copyright 2017 Voxbox.io
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SERVICE=freeswitch
IP=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
echo "---------------------------------------------------------------------"
echo "Cleaning up"
echo "---------------------------------------------------------------------"
$DIR/cleanup.sh
echo "---------------------------------------------------------------------"
echo "Running"
echo "---------------------------------------------------------------------"
docker run --rm -d \
  --name ${SERVICE} \
  --net host \
  --cap-add NET_ADMIN \
  --cap-add NET_BROADCAST \
  --cap-add SYS_RAWIO \
  --cap-add SYS_NICE \
  --cap-add SYS_TIME \
  --ulimit core=-1 \
  --ulimit nofile=999999 \
  --ulimit stack=250000 \
  --ulimit nproc=60000 \
  --ulimit rtprio=-1 \
  --ulimit sigpending=-1 \
  --ulimit msgqueue=-1 \
  --ulimit memlock=-1 \
  --volume ${DIR}/conf/docker:/opt/freeswitch/conf \
  voxbox/freeswitch:latest
echo "---------------------------------------------------------------------"
echo "Running tests"
echo "---------------------------------------------------------------------"
$DIR/test.sh
echo "---------------------------------------------------------------------"
echo "Logfile"
echo "---------------------------------------------------------------------"
docker logs ${SERVICE} -f