#!/usr/bin/env ruby

require 'bundler/setup'
require 'cloudformation-ruby-dsl/cfntemplate'
require 'cloudformation-ruby-dsl/spotprice'
require 'cloudformation-ruby-dsl/table'

template do

  value :AWSTemplateFormatVersion => '2010-09-09'

  value :Description => 'AWS CloudFormation Sample Template EC2InstanceWithSecurityGroupSample: Create an Amazon EC2 instance running the Amazon Linux AMI. The AMI is chosen based on the region in which the stack is run. This example creates an EC2 security group for the instance to give you SSH access. **WARNING** This template creates an Amazon EC2 instance. You will be billed for the AWS resources used if you create a stack from this template.'

  parameter 'Label',
            :Description => 'The label to apply to the servers.',
            :Type => 'String',
            :MinLength => '2',
            :MaxLength => '25',
            :AllowedPattern => '[_a-zA-Z0-9]*',
            :ConstraintDescription => 'Maximum length of the Label parameter may not exceed 25 characters and may only contain letters, numbers and underscores.',
            # The :Immutable attribute is a Ruby CFN extension.  It affects the behavior of the '<template> update ...'
            # operation in that a stack update may not change the values of parameters marked w/:Immutable => true.
            :Immutable => true
  
  parameter 'KeyPairName',
            :Description => 'Name of an existing EC2 KeyPair to enable SSH access to the instance',
            :Type => 'AWS::EC2::KeyPair::KeyName',
            :Default => 'free_tier_keys',
            :ConstraintDescription => 'must be the name of an existing EC2 KeyPair.'

  parameter 'InstanceType',
            :Description => 'WebServer EC2 instance type',
            :Type => 'String',
            :Default => 't2.micro',
            :AllowedValues => %w(t1.micro t2.nano t2.micro t2.small t2.medium t2.large m1.small m1.medium m1.large m1.xlarge m2.xlarge m2.2xlarge m2.4xlarge m3.medium m3.large m3.xlarge m3.2xlarge m4.large m4.xlarge m4.2xlarge m4.4xlarge m4.10xlarge c1.medium c1.xlarge c3.large c3.xlarge c3.2xlarge c3.4xlarge c3.8xlarge c4.large c4.xlarge c4.2xlarge c4.4xlarge c4.8xlarge g2.2xlarge g2.8xlarge r3.large r3.xlarge r3.2xlarge r3.4xlarge r3.8xlarge i2.xlarge i2.2xlarge i2.4xlarge i2.8xlarge d2.xlarge d2.2xlarge d2.4xlarge d2.8xlarge hi1.4xlarge hs1.8xlarge cr1.8xlarge cc2.8xlarge cg1.4xlarge),
            :ConstraintDescription => 'must be a valid EC2 instance type.'
  
  parameter 'ImageId',
            :Description => 'EC2 Image ID',
            :Type => 'String',
            :Default => 'ami-8c122be9',
            :AllowedPattern => 'ami-[a-f0-9]{8}',
            :ConstraintDescription => 'Must be ami-XXXXXXXX (where X is a hexadecimal digit)'

  parameter 'SSHLocation',
            :Description => 'The IP address range that can be used to SSH to the EC2 instances',
            :Type => 'String',
            :MinLength => '9',
            :MaxLength => '18',
            :Default => '0.0.0.0/0',
            :AllowedPattern => '(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})/(\\d{1,2})',
            :ConstraintDescription => 'must be a valid IP CIDR range of the form x.x.x.x/x.'

    mapping 'AWSInstanceType2Arch',
            :'t2.micro' => { :Arch => 'HVM64' }
    
    mapping 'AWSRegionArch2AMI',
            :'us-east-2' => { :PV64 => 'NOT_SUPPORTED', :HVM64 => 'ami-8c122be9', :HVMG2 => 'NOT_SUPPORTED' }
  

  resource 'SecurityGroup', :Type => 'AWS::EC2::SecurityGroup', :Properties => {
            :GroupDescription => 'Enable SSH access via port 22',
            :SecurityGroupIngress => [
            {
                :IpProtocol => 'tcp',
                :FromPort => '22',
                :ToPort => '22',
                :CidrIp => ref('SSHLocation'),
            },
            {
                :IpProtocol => 'tcp',
                :FromPort => '80',
                :ToPort => '80',
                :CidrIp => ref('SSHLocation'),
            },
            {
                :IpProtocol => 'tcp',
                :FromPort => '8140',
                :ToPort => '8140',
                :CidrIp => ref('SSHLocation'),
            },
      ],
  }


#   resource 'SecurityGroup', :Type => 'AWS::EC2::SecurityGroup', :Properties => {
#     :GroupDescription => 'Lets any vpc traffic in.',
#     :SecurityGroupIngress => {:IpProtocol => '-1', :FromPort => '0', :ToPort => '65535', :CidrIp => "10.0.0.0/8"}
# }

        
  resource "ASGElasticsearch", :Type => 'AWS::AutoScaling::AutoScalingGroup', :Properties => {
            :AvailabilityZones => ['us-east-2a'],
            :HealthCheckType => 'EC2',
            :LaunchConfigurationName => ref('LaunchConfigELS'),
            :MinSize => 1,
            :MaxSize => 5,
            :NotificationConfiguration => {
                :TopicARN => ref('EmailSNSTopic'),
                :NotificationTypes => %w(autoscaling:EC2_INSTANCE_LAUNCH autoscaling:EC2_INSTANCE_LAUNCH_ERROR autoscaling:EC2_INSTANCE_TERMINATE autoscaling:EC2_INSTANCE_TERMINATE_ERROR),
            },
            :Tags => [
            {
                :Key => 'Name',
                :Value => 'Elasticsearch',
                :PropagateAtLaunch => 'true',
            },
            {
                :Key => 'Label',
                :Value => parameters['Label'],
                :PropagateAtLaunch => 'true',
            }
        ],
 }   


  resource 'EmailSNSTopic', :Type => 'AWS::SNS::Topic', :Properties => {
    :Subscription => [
        {
            :Endpoint => 'yzaho@softserveinc.com',
            :Protocol => 'email',
        },
    ],
 }

#   resource 'WaitConditionHandle', :Type => 'AWS::CloudFormation::WaitConditionHandle', :Properties => {}

#   resource 'WaitCondition', :Type => 'AWS::CloudFormation::WaitCondition', :DependsOn => 'ASGKibana', :Properties => {
#             :Handle => ref('WaitConditionHandle'),
#             :Timeout => 240,
#             :Count => "1"
#   }

  resource 'LaunchConfigELS', :Type => 'AWS::AutoScaling::LaunchConfiguration', :Properties => {
            :ImageId => 'ami-8c122be9',
            :KeyName => ref('KeyPairName'),
            :InstanceType => ref('InstanceType'),
            :InstanceMonitoring => 'false',
            :SecurityGroups => [ref('SecurityGroup')],
    # Loads an external userdata script with an interpolated argument.
            :UserData => base64(interpolate(file('install_elstsch.sh'))),
  }


end.exec!
