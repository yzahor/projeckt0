#!/usr/bin/env bash

#Add repository 
#APT like Debian
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list




#Install Kibana
sudo apt-get update && sudo apt-get install kibana

#Running Kibana with SysV init
#sudo update-rc.d kibana defaults 95 10

#Running Kibana with systemd
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service
sudo systemctl start kibana.service