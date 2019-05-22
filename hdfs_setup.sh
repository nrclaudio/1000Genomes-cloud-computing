#!/bin/sh
sudo apt update
sudo apt-get install -y openjdk-8-jdk
cd
echo "127.0.0.1 localhost
130.238.29.217 master-1320-2
130.238.29.179 hdfs-slave1-1320
130.238.29.198 hdfs-slave2-1320

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts" | sudo tee /etc/hosts

cd
wget http://apache.mirrors.spacedump.net/hadoop/common/hadoop-2.8.5/hadoop-2.8.5.tar.gz
tar -xzf hadoop-2.8.5.tar.gz
mv hadoop-2.8.5 hadoop

echo 'PATH=/home/ubuntu/hadoop/bin:/home/ubuntu/hadoop/sbin:$PATH' | sudo tee -a /home/ubuntu/.profile
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/" | sudo tee -a /home/ubuntu/hadoop/etc/hadoop/hadoop-env.sh

# On each node update home/ubuntu/hadoop/etc/hadoop/core-site.xml you want to set the NameNode location to HOSTNAME on port 9000

echo "<?xml version='1.0' encoding='UTF-8'?>
<?xml-stylesheet type='text/xsl' href='configuration.xsl'?>
    <configuration>
        <property>
            <name>fs.defaultFS</name>
            <value>hdfs://130.238.29.217:9000</value>
        </property>
        <property>
            <name>hadoop.tmp.dir</name>
            <value>/home/ubuntu/hdfs/tmp</value>
        </property>
    </configuration>" | sudo tee /home/ubuntu/hadoop/etc/hadoop/core-site.xml

9868
echo "<?xml version='1.0' encoding='UTF-8'?>
<?xml-stylesheet type='text/xsl' href='configuration.xsl'?>
<configuration>
    <property>
            <name>dfs.namenode.name.dir</name>
            <value>file:///home/ubuntu/data/</value>
    </property>

    <property>
            <name>dfs.datanode.data.dir</name>
            <value>file:///home/ubuntu/data/</value>
    </property>

    <property>
            <name>dfs.replication</name>
            <value>2</value>
    </property>
</configuration>" | sudo tee /home/ubuntu/hadoop/etc/hadoop/hdfs-site.xml

sudo mkdir -p /home/ubuntu/data/
sudo chown ubuntu:ubuntu -R /home/ubuntu/data/
chmod 700 /home/ubuntu/data/
#The last property, dfs.replication, indicates how many times data is replicated in the cluster. You can set 2 to have all the data duplicated on the two nodes. Don’t enter a value higher than the actual number of slave nodes.

echo "<?xml version='1.0' encoding='UTF-8'?>
<?xml-stylesheet type='text/xsl' href='configuration.xsl'?>
<configuration>
    <property>
            <name>mapreduce.framework.name</name>
            <value>yarn</value>
    </property>
    <property>
        <name>mapreduce.jobtracker.address</name>
        <value>master-1320-2:54311</value>
    </property>
    <property>
        <name>yarn.app.mapreduce.am.resource.mb</name>
        <value>512</value>
    </property>

    <property>
        <name>mapreduce.map.memory.mb</name>
        <value>256</value>
    </property>

    <property>
        <name>mapreduce.reduce.memory.mb</name>
        <value>256</value>
    </property>
</configuration>" | sudo tee /home/ubuntu/hadoop/etc/hadoop/mapred-site.xml

echo "<?xml version='1.0'?>
<configuration>
    <property>
            <name>yarn.acl.enable</name>
            <value>0</value>
    </property>

    <property>
            <name>yarn.resourcemanager.hostname</name>
            <value>master-1320-2</value>
    </property>

    <property>
            <name>yarn.nodemanager.aux-services</name>
            <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.resource.memory-mb</name>
        <value>1536</value>
    </property>

    <property>
        <name>yarn.scheduler.maximum-allocation-mb</name>
        <value>1536</value>
    </property>

    <property>
        <name>yarn.scheduler.minimum-allocation-mb</name>
        <value>128</value>
    </property>

    <property>
        <name>yarn.nodemanager.vmem-check-enabled</name>
        <value>false</value>
    </property>
</configuration>
" | sudo tee /home/ubuntu/hadoop/etc/hadoop/yarn-site.xml

echo "hdfs-slave2-1320
hdfs-slave1-1320" | sudo tee /home/ubuntu/hadoop/etc/hadoop/slaves
echo "master-1320-2" | sudo tee /home/ubuntu/hadoop/etc/hadoop/masters


#Before this step we have to configure ssh between the machines, to do that we create a new keypair on the master machine and transfer the public key to every machine. In order to sshd-copy-id to the machines we first need to disable keypair authentication (enabling password authentication) on the slaves. to do that we can edit a line on sshd_config. Then we set up a password for the root user in linux.

cd
scp hadoop-*.tar.gz hdfs_slave2_1320:/home/ubuntu/
scp hadoop-*.tar.gz hdfs_slave1_1320:/home/ubuntu/

