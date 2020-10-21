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
        /opt/hadoop/bin/hdfs namenode -format matser && /opt/hadoop/sbin/start-dfs.sh
else
        echo "I'm a datanode"
	sleep 30
        # /opt/hadoop/sbin/start-dfs.sh
fi

while true; do sleep 3600; done
