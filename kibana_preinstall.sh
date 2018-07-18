#!/usr/bin/env bash

sudo rpm -Uvh https://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm
sudo yum -y update
sudo yum -y install java-1.8.0-openjdk.x86_64 aws-cfn-bootstrap puppet-agent git
echo -e "127.0.0.1   puppet" | sudo tee -a /etc/hosts
sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
sudo /opt/puppetlabs/bin/puppet module install puppet-yum
sudo mkdir /opt/puppetlabs/manifests
cd /opt/puppetlabs/manifests
sudo wget https://raw.githubusercontent.com/yzahor/project0/firstbranch/install_kibana.pp && sudo /opt/puppetlabs/bin/puppet apply install_kibana.pp

# sudo apt install -y aws-cfn-bootstrap
# sudo /opt/aws/bin/cfn-signal -e 0 --stack, {"Ref": "AWS::StackName"}, 
