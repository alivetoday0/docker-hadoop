FROM alivetoday0/ubuntu-ssh-java11

RUN mkdir /var/log/hadoop

ENV HADOOP_VERSION=2.10.1
ENV HADOOP_DOWNLOAD_URL=https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

COPY file/hadoop-2.10.1.tar.gz /tmp/hadoop.tar.gz
RUN tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz \
    && ln -s /opt/hadoop-$HADOOP_VERSION /opt/hadoop \
    && mkdir -p /opt/hadoop/dfs/master \
    && mkdir -p /opt/hadoop/dfs/slave \
    && mkdir /opt/hadoop/logs \
    && ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop \
    && rm -rf /opt/hadoop/share/doc

ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_CONFIG_HOME /etc/hadoop
ENV PATH $HADOOP_HOME/bin/:$PATH
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

ADD config/core-site.xml /etc/hadoop/
ADD config/hdfs-site.xml /etc/hadoop/
ADD config/mapred-site.xml /etc/hadoop/
ADD config/slaves /etc/hadoop/
ADD script/healthcheck-ssh.sh /root/
ADD script/wait-for-ssh.sh /root/ 

RUN chmod 755 ~/healthcheck-ssh.sh \
    && chmod 755 ~/wait-for-ssh.sh

RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64:' $HADOOP_CONFIG_HOME/hadoop-env.sh

EXPOSE 50070 9000 50075 50010
