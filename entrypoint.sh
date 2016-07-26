#!/bin/bash

echo ${MYID:-1} > /zookeeper/data/myid

if [ -n "$SERVERS" ]; then
	IFS=\, read -a servers <<<"$SERVERS"
	for i in "${!servers[@]}"; do 
		printf "\nserver.%i=%s:2888:3888" "$((1 + $i))" "${servers[$i]}" >> /zookeeper/conf/zoo.cfg
	done
fi

conf_path=/opt/zookeeper/conf/zoo.cfg

if [ -n "$ZOO_CFG" ]; then
	echo $ZOO_CFG >> $conf_path
fi

#
# Optional SSL configuration
#

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

if [ -n "$ZOO_CFG" ]; then
	echo $ZOO_CFG >> $conf_path
fi

cd /zookeeper
exec "$@"
