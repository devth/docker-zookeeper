#!/bin/bash

echo ${MYID:-1} > /zookeeper/data/myid

if [ -n "$SERVERS" ]; then
	IFS=\, read -a servers <<<"$SERVERS"
	for i in "${!servers[@]}"; do 
		printf "\nserver.%i=%s:2888:3888" "$((1 + $i))" "${servers[$i]}" >> /zookeeper/conf/zoo.cfg
	done
fi

if [ -n "$ZOO_CFG" ]; then
	echo $ZOO_CFG >> /zookeeper/conf/zoo.cfg
fi

cd /zookeeper
exec "$@"
