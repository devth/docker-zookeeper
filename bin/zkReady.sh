#!/bin/bash

/zookeeper/bin/zkServer.sh status | egrep 'Mode: (standalone|leader|follower|observing)'
