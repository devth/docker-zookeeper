[![](https://badge.imagelayers.io/devth/zookeeper:latest.svg)](https://imagelayers.io/?images=devth/zookeeper:latest 'devth/zookeeper:latest')

ZooKeeper image based on the mesoscloud/zookeeper image. Modified by turning on
quorumListenOnAllIP on the config file. This allows a ZooKeeper ensemble to
operate within Kubernetes using Service IP addresses.

The following Kubernetes config will create a reliable three node ZK ensemble.
The ZK containers will be restarted if they terminate within their node, and
they will be started in a new node if their current node dies.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: zookeeper
spec:
  ports:
    - name: client
      port: 2181
  selector:
    app: zookeeper
---
apiVersion: v1
kind: Service
metadata:
  name: zookeeper-1
spec:
  ports:
    - name: client
      port: 2181
    - name: followers
      port: 2888
    - name: election
      port: 3888
  selector:
    app: zookeeper
    server-id: "1"
---
apiVersion: v1
kind: Service
metadata:
  name: zookeeper-2
spec:
  ports:
    - name: client
      port: 2181
    - name: followers
      port: 2888
    - name: election
      port: 3888
  selector:
    app: zookeeper
    server-id: "2"
---
apiVersion: v1
kind: Service
metadata:
  name: zookeeper-3
spec:
  ports:
    - name: client
      port: 2181
    - name: followers
      port: 2888
    - name: election
      port: 3888
  selector:
    app: zookeeper
    server-id: "3"
---
apiVersion: v1
kind: ReplicationController
metadata:
  name: zookeeper-1
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: zookeeper
        server-id: "1"
    spec:
      volumes:
        - name: data
          emptyDir: {}
        - name: wal
          emptyDir:
            medium: Memory
      containers:
        - name: server
          image: devth/zookeeper:latest
          env:
            - name: MYID
              value: "1"
            - name: SERVERS
              value: "zookeeper-1,zookeeper-2,zookeeper-3"
            - name: JVMFLAGS
              value: "-Xmx2G"
          ports:
            - containerPort: 2181
            - containerPort: 2888
            - containerPort: 3888
          volumeMounts:
            - mountPath: /zookeeper/data
              name: data
            - mountPath: /zookeeper/wal
              name: wal
---
apiVersion: v1
kind: ReplicationController
metadata:
  name: zookeeper-2
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: zookeeper
        server-id: "2"
    spec:
      volumes:
        - name: data
          emptyDir: {}
        - name: wal
          emptyDir:
            medium: Memory
      containers:
        - name: server
          image: devth/zookeeper:latest
          env:
            - name: MYID
              value: "2"
            - name: SERVERS
              value: "zookeeper-1,zookeeper-2,zookeeper-3"
            - name: JVMFLAGS
              value: "-Xmx2G"
          ports:
            - containerPort: 2181
            - containerPort: 2888
            - containerPort: 3888
          volumeMounts:
            - mountPath: /zookeeper/data
              name: data
            - mountPath: /zookeeper/wal
              name: wal
---
apiVersion: v1
kind: ReplicationController
metadata:
  name: zookeeper-3
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: zookeeper
        server-id: "3"
    spec:
      volumes:
        - name: data
          emptyDir: {}
        - name: wal
          emptyDir:
            medium: Memory
      containers:
        - name: server
          image: devth/zookeeper:latest
          env:
            - name: MYID
              value: "3"
            - name: SERVERS
              value: "zookeeper-1,zookeeper-2,zookeeper-3"
            - name: JVMFLAGS
              value: "-Xmx2G"
          ports:
            - containerPort: 2181
            - containerPort: 2888
            - containerPort: 3888
          volumeMounts:
            - mountPath: /zookeeper/data
              name: data
            - mountPath: /zookeeper/wal
              name: wal
```
