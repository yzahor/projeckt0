#!/usr/bin/env bash

#Import Elasticsearch GPG key
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

#Add Elasticsearch to repository
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
sudo apt update

#Install Elasticsearch
sudo apt install elasticsearch
