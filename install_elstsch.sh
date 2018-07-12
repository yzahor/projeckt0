#!/usr/bin/env bash
#
#=========YUM/RPM like CentOS======#######################################################################
#
#Add Elasticsearch to repository
sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
#sudo touch /etc/yum.repos.d/elasticsearch.repo
sudo touch /etc/yum.repos.d/elastic-6.x.repo
echo -e "[elastic-6.x]
name=Elastic repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md" | sudo tee -a /etc/yum.repos.d/elastic-6.x.repo
#
#Installing from the RPM repository
sudo yum -y update
sudo yum -y install java-1.8.0-openjdk aws-cfn-bootstrap
#sudo alternatives --set java  /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java
sudo yum -y install elasticsearch
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

#sudo chkconfig --add elasticsearch && sudo service elasticsearch start
#
#=========APT like Debian=====##########################################################################
#
#Import Elasticsearch GPG key
# wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
#
# #Add Elasticsearch to repository
# echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
# sudo apt update
#
# #Install Elasticsearch
# sudo apt install elasticsearch
