#!/bin/bash

# java installation
apt-get --assume-yes update
apt-get --assume-yes install software-properties-common python-software-properties
add-apt-repository ppa:openjdk-r/ppa -y
apt-get --assume-yes update
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
apt-get --assume-yes install openjdk-8-jdk

# hadoop installation
cd /usr/local
if [ ! -f hadoop-1.2.1.tar.gz ];
then
  wget https://archive.apache.org/dist/hadoop/core/hadoop-1.2.1/hadoop-1.2.1.tar.gz
fi

if [ ! -f hadoop-1.2.1 ];
then
  tar xzf hadoop-1.2.1.tar.gz
  chown -R root:root hadoop-1.2.1

  # setup Hadoop environment variables
  sh -c 'echo export HADOOP_PREFIX=/usr/local/hadoop-1.2.1 >> /root/.bashrc'
  sh -c 'echo export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 >> /root/.bashrc'
  sh -c 'echo 'export PATH=$PATH:$HADOOP_PREFIX/bin' >> /root/.bashrc'
  source /root/.bashrc

  # create base directory for hadoop temporary data
  mkdir -p /app/hadoop/tmp
  chown root:root /app/hadoop/tmp
fi
