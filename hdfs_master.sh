#!/bin/sh
sudo apt update
sudo apt-get install -y openjdk-8-jdk
IP=`curl ifconfig.me`
HOSTNAME=`hostname`
cd
wget http://apache.mirrors.spacedump.net/hadoop/common/hadoop-3.1.2/hadoop-3.1.2.tar.gz
tar -xzf hadoop-3.1.2.tar.gz
mv hadoop-3.1.2 hadoop
rm hadoop-3.1.2.tar.gz
echo 'PATH=/home/ubuntu/hadoop/bin:/home/ubuntu/hadoop/sbin:$PATH' | tee -a /home/ubuntu/.profile
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/" | sudo tee -a /home/ubuntu/hadoop/etc/hadoop/hadoop-env.sh

