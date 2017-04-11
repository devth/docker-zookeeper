#!/bin/bash

set -euo pipefail

conf_path=/zookeeper/conf/zoo.cfg

echo "Configuring myid"
# Parse MYID or use a default value of 1
myid=1
# If MYID_PARSE is defined, parse MYID out of it
if [[ $MYID_PARSE =~ (.*)-([0-9]+)$ ]]; then
  echo "Parsing myid from $MYID_PARSE"
  # NAME=${BASH_REMATCH[1]}
  ORD=${BASH_REMATCH[2]}
  # StatefulSet ordinals are 0-based but myid is 1-based
  myid=$((ORD+1))
else
  echo "Failed to extract myid from: $MYID_PARSE"
  if [ -n "$MYID" ]; then
    myid="$MYID"
  else
    echo "Failed to find myid from: $MYID. Defaulting to 1"
  fi
fi

# toss the computed `myid` in config:
echo "myid: $myid"
echo "$myid" > /zookeeper/data/myid


if [ -n "$SERVERS" ]; then
  echo "Adding $SERVERS to $conf_path"
  IFS=\, read -r -a servers <<<"$SERVERS"
  for i in "${!servers[@]}"; do 
    printf "\nserver.%i=%s:2888:3888" "$((1 + i))" "${servers[$i]}" >> $conf_path
  done
  echo "" >> $conf_path
else
  echo "Warning: servers is not defined: $SERVERS"
fi

#
# Optional SSL configuration
#

echo "Checking for SSL config"
if [ -n "$SSL_KEYSTORE_LOCATION" ]; then
  echo "ssl.keyStore.location=$SSL_KEYSTORE_LOCATION" >> $conf_path
fi

if [ -n "$SSL_KEYSTORE_PASSWORD" ]; then
  echo "ssl.keyStore.password=$SSL_KEYSTORE_PASSWORD" >> $conf_path
fi

if [ -n "$SSL_TRUSTSTORE_LOCATION" ]; then
  echo "ssl.trustStore.location=$SSL_TRUSTSTORE_LOCATION" >> $conf_path
fi

if [ -n "$SSL_TRUSTSTORE_PASSWORD" ]; then
  echo "ssl.trustStore.password=$SSL_TRUSTSTORE_PASSWORD" >> $conf_path
fi

#
# Other optional configuration from ZOO_CFG env var
#

echo "Checking for other config in $ZOO_CFG"
if [ -n "$ZOO_CFG" ]; then
  echo "$ZOO_CFG" >> $conf_path
fi


cd /zookeeper
echo "Starting: $*"
exec "$@"
