FROM alivetoday0/ubuntu-ssh-java11

RUN apt install -y curl

ENV SPARK_VERSION=2.4.7
ENV SPARK_DOWNLOAD_URL=https://downloads.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-without-hadoop.tgz

RUN curl -fSL "$SPARK_DOWNLOAD_URL" -o /tmp/spark.tgz \
  && tar -xvf /tmp/spark.tgz -C /opt/ \
  && rm /tmp/spark.tar.gz \
  && ln -s /opt/spark-$SPARK_VERSION-$SPARK_VERSION_OPTION /opt/spark \
  && ln -s /opt/spark-$SPARK_VERSION-$SPARK_VERSION_OPTION/conf /etc/spark

ENV SPARK_HOME /opt/spark
ENV SPARK_CONF_HOME /etc/spark
ENV PATH $PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
