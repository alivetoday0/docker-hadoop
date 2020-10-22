#!/bin/bash

service ssh start

until ssh -o ConnectTimeout=1 slave01 /root/healthcheck-ssh.sh; do
        echo "ssh is not running"
        sleep 10
done

until ssh -o ConnectTimeout=1 slave02 /root/healthcheck-ssh.sh; do
        echo "ssh is not running"
        sleep 10
done

until ssh -o ConnectTimeout=1 slave03 /root/healthcheck-ssh.sh; do
        echo "ssh is not running"
        sleep 10
done

if [ "$HOSTNAME" == "master" ]; then
        echo "I'm a namenode"
        $HADOOP_HOME/bin/hdfs namenode -format matser \
        && $HADOOP_HOME/sbin/start-dfs.sh \
        && $HADOOP_HOME/sbin/start-yarn.sh \
        && $HADOOP_HOME/sbin/mr-jobhistory-daemon.sh --config $HADOOP_CONF_HOME start historyserver \
        && hadoop fs -mkdir /spark/ \
        && hadoop fs -mkdir /spark/shared-logs/
else
        echo "I'm a datanode"
        sleep 30
fi

while true; do sleep 3600; done
