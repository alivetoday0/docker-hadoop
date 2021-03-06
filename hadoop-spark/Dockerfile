FROM alivetoday0/ubuntu-ssh-java11

RUN apt install -y curl
RUN mkdir /var/log/hadoop

ENV HADOOP_VERSION=2.10.1
ENV HADOOP_DOWNLOAD_URL=https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

ENV SPARK_VERSION=2.4.7
ENV SPARK_VERSION_OPTION=bin-without-hadoop
ENV SPARK_DOWNLOAD_URL=https://downloads.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-$SPARK_VERSION_OPTION.tgz

RUN curl -fSL "$HADOOP_DOWNLOAD_URL" -o /tmp/hadoop.tar.gz \
  && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
  && rm /tmp/hadoop.tar.gz \
  && ln -s /opt/hadoop-$HADOOP_VERSION /opt/hadoop \
  && mkdir -p /opt/hadoop/dfs/master \
  && mkdir -p /opt/hadoop/dfs/slave \
  && mkdir /opt/hadoop/logs \
  && ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop \
  && rm -rf /opt/hadoop/share/doc \
  && curl -fSL "$SPARK_DOWNLOAD_URL" -o /tmp/spark.tgz \
  && tar -xvf /tmp/spark.tgz -C /opt/ \
  && rm /tmp/spark.tgz \
  && ln -s /opt/spark-$SPARK_VERSION-$SPARK_VERSION_OPTION /opt/spark \
  && ln -s /opt/spark-$SPARK_VERSION-$SPARK_VERSION_OPTION/conf /etc/spark

# set environment
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_CONF_DIR /etc/hadoop
ENV PATH $HADOOP_HOME/bin/:$PATH

ENV SPARK_HOME /opt/spark
ENV SPARK_CONF_HOME /etc/spark
ENV LD_LIBRARY_PATH $HADOOP_HOME/lib/native:$LD_LIBRARY_PATH
ENV PATH $PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

# add configuration file from host
ADD config/core-site.xml $HADOOP_CONF_DIR
ADD config/hdfs-site.xml $HADOOP_CONF_DIR
ADD config/mapred-site.xml $HADOOP_CONF_DIR
ADD config/slaves $HADOOP_CONF_DIR
ADD config/yarn-site.xml $HADOOP_CONF_DIR
ADD config/slaves $SPARK_CONF_HOME

ADD script/healthcheck-ssh.sh /root/
ADD script/wait-for-ssh.sh /root/

# execute command
RUN chmod 755 ~/healthcheck-ssh.sh \
  && chmod 755 ~/wait-for-ssh.sh \
  && sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64:' $HADOOP_CONF_DIR/hadoop-env.sh \
  && cp $SPARK_CONF_HOME/spark-defaults.conf.template $SPARK_CONF_HOME/spark-defaults.conf \
  && sed -i '/#[ ]*spark.master/ s:.*:spark.master yarn:' $SPARK_CONF_HOME/spark-defaults.conf \
  && sed -i '/#[ ]*spark.eventLog.enabled/ s:.*:spark.eventLog.enabled true:' $SPARK_CONF_HOME/spark-defaults.conf \
  && echo "spark.eventLog.dir hdfs://master:9000/spark/shared-logs/" >> $SPARK_CONF_HOME/spark-defaults.conf \
  && touch $SPARK_CONF_HOME/spark-env.sh \
  && echo "export HADDOP_CONF_DIR=$HADOOP_CONF_DIR" >> $SPARK_CONF_HOME/spark-env.sh \
  && echo "export SPARK_DIST_CLASSPATH=$(/opt/hadoop/bin/hadoop classpath)" >> $SPARK_CONF_HOME/spark-env.sh \
  && echo "export SPARK_CLASSPATH=$SPARK_HOME/jars" >> $SPARK_CONF_HOME/spark-env.sh \
  && echo "export JAVA_HOME=$JAVA_HOME" >> $SPARK_CONF_HOME/spark-env.sh \
  && chmod 755 $SPARK_CONF_HOME/spark-env.sh

EXPOSE 50070 9000 50075 50010
EXPOSE 8080 18080 7077
