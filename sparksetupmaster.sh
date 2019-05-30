sudo apt update
sudo apt-get install -y openjdk-8-jdk
for i in {1..255}; do echo "192.168.1.$i host-192-168-1-$i-ldsa" | sudo tee -a /etc/hosts; done
for i in {1..255}; do echo "192.168.2.$i host-192-168-2-$i-ldsa" | sudo tee -a /etc/hosts; done
sudo hostname host-$(hostname -I | awk '{$1=$1};1' | sed 's/\./-/'g)-ldsa ; hostname
cd ~
wget http://apache.mirrors.spacedump.net/spark/spark-2.4.3/spark-2.4.3-bin-hadoop2.7.tgz
tar -zxvf spark-2.4.3-bin-hadoop2.7.tgz
echo "export SPARK_HOME=~/spark-2.4.2-bin-hadoop2.7" >> ~/.bashrc
source ~/.bashrc
cd ~/spark-2.4.3-bin-hadoop2.7/
~/spark-2.4.3-bin-hadoop2.7/sbin/start-master.sh
