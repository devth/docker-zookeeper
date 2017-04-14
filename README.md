# docker-zookeeper

Meant to be run on Kubernetes.

[![Docker Automated build](https://img.shields.io/docker/automated/devth/docker-zookeeper.svg?style=flat-square)](https://hub.docker.com/r/devth/docker-zookeeper/)

ZooKeeper image based on eliaslevy/docker-zookeeper which is based on the
mesoscloud/zookeeper image.

eliaslevy/docker-zookeeper modification:

- turn on quorumListenOnAllIP on the config file. This allows a ZooKeeper
  ensemble to operate within Kubernetes using Service IP addresses.

devth/docker-zookeeper modification:

- upgrade to ZooKeeper 3.5.2-alpha for SSL support
- support configuring all ssl properties via ENV vars
- support any additional config in a `ZOO_CFG` var
- expose secure client port 2281 in the docker image
- allow parsing a 0-based ordinal out of `MYID_PARSE` (for StatefulSets)
