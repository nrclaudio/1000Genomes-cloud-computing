#!/bin/sh
sudo apt update
sudo apt-get install -y openjdk-8-jdk
IP=`curl ifconfig.me`
HOSTNAME=`hostname`
cd
wget http://apache.mirrors.spacedump.net/hadoop/common/hadoop-3.1.2/hadoop-3.1.2.tar.gz
tar -xzf hadoop-3.1.2-src.tar.gz
mv hadoop-3.1.2-src hadoop
rm hadoop-3.1.2-src.tar.gz
echo '\nPATH=/home/ubuntu/hadoop/bin:/home/ubuntu/hadoop/sbin:$PATH' | tee -a /home/hadoop/.profile
echo "/usr/lib/jvm/java-8-openjdk-amd64/jre/" | sudo tee -a
