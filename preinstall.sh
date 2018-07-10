#!/usr/bin/env bash

sudo yum -y update
sudo yum -y install oracle-java8-installer aws-cfn-bootstrap

# sudo apt install -y aws-cfn-bootstrap
# sudo /opt/aws/bin/cfn-signal -e 0 --stack, {"Ref": "AWS::StackName"}, 
