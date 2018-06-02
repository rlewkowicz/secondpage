FROM ubuntu:16.04

RUN apt update \
 && apt install -y locales software-properties-common python-software-properties
 # \
 # && dpkg-reconfigure -f noninteractive locales \
 # && locale-gen C.UTF-8 \
 # && /usr/sbin/update-locale LANG=C.UTF-8 \
 # && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
 # && locale-gen

 RUN echo debconf shared/accepted-oracle-license-v1-1 select true | \
   debconf-set-selections && \
 echo debconf shared/accepted-oracle-license-v1-1 seen true | \
   debconf-set-selections

 RUN add-apt-repository ppa:webupd8team/java -y && \
 apt update && \
 apt-get install -y oracle-java8-installer

 RUN echo "JAVA_HOME=$(which java)" | tee -a /etc/environment

# Users with other locales should set this in their derivative image
# ENV LANG en_US.UTF-8
# ENV LANGUAGE en_US:en
# ENV LC_ALL en_US.UTF-8

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

# # JAVA
# ARG JAVA_MAJOR_VERSION=10.0.1
# ARG JAVA_UPDATE_VERSION=10
# ARG JAVA_BUILD_NUMBER=11
# ENV JAVA_HOME /usr/jdk-${JAVA_MAJOR_VERSION}
#
#
# ENV PATH $PATH:$JAVA_HOME/bin
# RUN curl -sL --retry 3 --insecure \
#   --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
#   "http://download.oracle.com/otn-pub/java/jdk/${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-b${JAVA_BUILD_NUMBER}/d54c1d3a095b4ff2b6607d096fa80163/server-jre-${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-linux-x64.tar.gz" \
#   | gunzip \
#   | tar x -C /usr/ \
#   && ln -s $JAVA_HOME /usr/java \
#   && rm -rf $JAVA_HOME/man
# # ENV PATH $PATH:$JAVA_HOME/bin
# # RUN wget --header="Cookie: oraclelicense=accept-securebackup-cookie;" http://download.oracle.com/otn-pub/java/jdk/10.0.1+10/fb4372174a714e6b8c52526dc134031e/serverjre-10.0.1_linux-x64_bin.tar.gz \
# #   && tar -xzf serverjre-10.0.1_linux-x64_bin.tar.gz -C /usr/ \
# #   && ln -s $JAVA_HOME /usr/java \
# #   && rm -rf $JAVA_HOME/man

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

# SPARK
# ENV SPARK_VERSION 2.3.0
# ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-without-hadoop
# ENV SPARK_HOME /usr/spark-${SPARK_VERSION}
# ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"
# ENV PATH $PATH:${SPARK_HOME}/bin
# RUN curl -sL --retry 3 \
#   "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz" \
#   | gunzip \
#   | tar x -C /usr/ \
#  && mv /usr/$SPARK_PACKAGE $SPARK_HOME \
#  && chown -R root:root $SPARK_HOME

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



#Spark
# ENV CONNECTOR_HOME /usr/spark-cassandra-connector
# RUN wget https://github.com/datastax/spark-cassandra-connector/archive/d8a3eb4.zip && \
# unzip d8a3eb4.zip && mv spark-cassandra-connector* $CONNECTOR_HOME && cd $CONNECTOR_HOME && \
# sbt/sbt doc && \
# sbt/sbt package && \
# sbt/sbt assembly

COPY ./builds/secondpage-spark/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf

RUN echo "spark.driver.extraClassPath $CONNECTOR_HOME/spark-cassandra-connector/target/full/scala-2.11/spark-cassandra-connector-assembly-2.0.8-89-gd8a3eb4.jar" >> $SPARK_HOME/conf/spark-defaults.conf && \
echo "spark.executor.extraClassPath $CONNECTOR_HOME/spark-cassandra-connector/target/full/scala-2.11/spark-cassandra-connector-assembly-2.0.8-89-gd8a3eb4.jar" >> $SPARK_HOME/conf/spark-defaults.conf && \
echo "spark.cassandra.connection.host cassandra" >> $SPARK_HOME/conf/spark-defaults.conf

WORKDIR $SPARK_HOME
CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]
