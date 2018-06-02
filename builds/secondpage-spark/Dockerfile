FROM ubuntu:16.04

RUN apt update \
 && apt install -y locales software-properties-common python-software-properties

 RUN echo debconf shared/accepted-oracle-license-v1-1 select true | \
   debconf-set-selections && \
 echo debconf shared/accepted-oracle-license-v1-1 seen true | \
   debconf-set-selections

 RUN add-apt-repository ppa:webupd8team/java -y && \
 apt update && \
 apt-get install -y oracle-java8-installer

 RUN echo "JAVA_HOME=$(which java)" | tee -a /etc/environment

RUN apt-get update \
 && apt-get install -y curl unzip git wget \
    python3 python3-setuptools \
 && rm -f /usr/bin/python \
 && ln -s /usr/bin/python3 /usr/bin/python \
 && easy_install3 pip py4j \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# http://blog.stuart.axelbrooke.com/python-3-on-spark-return-of-the-pythonhashseed
ENV PYTHONHASHSEED 0
ENV PYTHONIOENCODING UTF-8
ENV PIP_DISABLE_PIP_VERSION_CHECK 1


# HADOOP
# ENV HADOOP_VERSION 2.8.3
# ENV HADOOP_HOME /usr/hadoop-$HADOOP_VERSION
# ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
# ENV PATH $PATH:$HADOOP_HOME/bin
# RUN curl -sL --retry 3 \
#   "http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
#   | gunzip \
#   | tar -x -C /usr/ \
#  && rm -rf $HADOOP_HOME/share/doc \
#  && chown -R root:root $HADOOP_HOME

#SPARK
ENV SPARK_COMMIT 992447fb30ee9ebb3cf794f2d06f4d63a2d792db
ENV SPARK_VERSION 2.3.0
ENV SPARK_PREFIX /usr
ENV SPARK_HOME /usr/spark-${SPARK_VERSION}
ENV _R_CHECK_FORCE_SUGGESTS_ false
RUN wget http://apache.claz.org/spark/spark-2.3.0/spark-2.3.0.tgz && tar -xzf spark-2.3.0.tgz -C $SPARK_PREFIX

# COPY ./builds/secondpage-spark/pom.xml $SPARK_HOME/pom.xml

RUN cd $SPARK_HOME && ./dev/make-distribution.sh --name custom-spark --pip --tgz -Phive -Phive-thriftserver -Pyarn -Pkubernetes -DskipTests

# SPARK CASSANDRA CONNECTOR
ENV CONNECTOR_COMMIT d8a3eb4
ENV CONNECTOR_HOME /usr/spark-cassandra-connector
RUN git clone https://github.com/datastax/spark-cassandra-connector $CONNECTOR_HOME && \
cd $CONNECTOR_HOME && git checkout $CONNECTOR_COMMIT && \
sbt/sbt doc && \
sbt/sbt package && \
sbt/sbt assembly

COPY ./builds/secondpage-spark/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf

RUN echo "spark.driver.extraClassPath $CONNECTOR_HOME/spark-cassandra-connector/target/full/scala-2.11/spark-cassandra-connector-assembly-2.0.8-89-gd8a3eb4.jar" >> $SPARK_HOME/conf/spark-defaults.conf && \
echo "spark.executor.extraClassPath $CONNECTOR_HOME/spark-cassandra-connector/target/full/scala-2.11/spark-cassandra-connector-assembly-2.0.8-89-gd8a3eb4.jar" >> $SPARK_HOME/conf/spark-defaults.conf && \
echo "spark.cassandra.connection.host cassandra" >> $SPARK_HOME/conf/spark-defaults.conf

WORKDIR $SPARK_HOME
CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]
