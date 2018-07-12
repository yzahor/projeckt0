#!/usr/bin/env bash

sudo yum -y update
sudo yum -y install java-1.8.0-openjdk aws-cfn-bootstrap

# sudo apt install -y aws-cfn-bootstrap
# sudo /opt/aws/bin/cfn-signal -e 0 --stack, {"Ref": "AWS::StackName"}, 
