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
            :Default => 'ami-6a003c0f',
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
          # :'t1.micro' => { :Arch => 'PV64' },
          # :'t2.nano' => { :Arch => 'HVM64' },
          :'t2.micro' => { :Arch => 'HVM64' }
          # :'t2.small' => { :Arch => 'HVM64' },
          # :'t2.medium' => { :Arch => 'HVM64' },
          # :'t2.large' => { :Arch => 'HVM64' },
          # :'m1.small' => { :Arch => 'PV64' },
          # :'m1.medium' => { :Arch => 'PV64' },
          # :'m1.large' => { :Arch => 'PV64' },
          # :'m1.xlarge' => { :Arch => 'PV64' },
          # :'m2.xlarge' => { :Arch => 'PV64' },
          # :'m2.2xlarge' => { :Arch => 'PV64' },
          # :'m2.4xlarge' => { :Arch => 'PV64' },
          # :'m3.medium' => { :Arch => 'HVM64' },
          # :'m3.large' => { :Arch => 'HVM64' },
          # :'m3.xlarge' => { :Arch => 'HVM64' },
          # :'m3.2xlarge' => { :Arch => 'HVM64' },
          # :'m4.large' => { :Arch => 'HVM64' },
          # :'m4.xlarge' => { :Arch => 'HVM64' },
          # :'m4.2xlarge' => { :Arch => 'HVM64' },
          # :'m4.4xlarge' => { :Arch => 'HVM64' },
          # :'m4.10xlarge' => { :Arch => 'HVM64' },
          # :'c1.medium' => { :Aus-east-1rch => 'PV64' },
          # :'c1.xlarge' => { :Aus-east-1rch => 'PV64' },
          # :'c3.large' => { :Arus-east-1ch => 'HVM64' },
          # :'c3.xlarge' => { :Aus-east-1rch => 'HVM64' },
          # :'c3.2xlarge' => { :Arch => 'HVM64' },
          # :'c3.4xlarge' => { :Arch => 'HVM64' },
          # :'c3.8xlarge' => { :Arch => 'HVM64' },Форкнул интересный 
          # :'c4.large' => { :Arch => 'HVM64' },
          # :'c4.xlarge' => { :Arch => 'HVM64' },
          # :'c4.2xlarge' => { :Arch => 'HVM64' },Форкнул интересный 
          # :'c4.4xlarge' => { :Arch => 'HVM64' },Форкнул интересный 
          # :'c4.8xlarge' => { :Arch => 'HVM64' },Форкнул интересный 
          # :'g2.2xlarge' => { :Arch => 'HVMG2' },Форкнул интересный 
          # :'g2.8xlarge' => { :Arch => 'HVMG2' },Форкнул интересный 
          # :'r3.large' => { :Arch => 'HVM64' },
          # :'r3.xlarge' => { :Arch => 'HVM64' },
          # :'r3.2xlarge' => { :Arch => 'HVM64' },
          # :'r3.4xlarge' => { :Arch => 'HVM64' },
          # :'r3.8xlarge' => { :Arch => 'HVM64' },
          # :'i2.xlarge' => { :Arch => 'HVM64' },
          # :'i2.2xlarge' => { :Arch => 'HVM64' },
          # :'i2.4xlarge' => { :Arch => 'HVM64' },
          # :'i2.8xlarge' => { :Arch => 'HVM64' },
          # :'d2.xlarge' => { :Arch => 'HVM64' },
          # :'d2.2xlarge' => { :Arch => 'HVM64' },
          # :'d2.4xlarge' => { :Arch => 'HVM64' },
          # :'d2.8xlarge' => { :Arch => 'HVM64' },
          # :'hi1.4xlarge' => { :Arch => 'HVM64' },
          # :'hs1.8xlarge' => { :Arch => 'HVM64' },
          # :'cr1.8xlarge' => { :Arch => 'HVM64' },
          # :'cc2.8xlarge' => { :Arch => 'HVM64' }

  # mapping 'AWSInstanceType2NATArch',
          # :'t1.micro' => { :Arch => 'NATPV64' },
          # :'t2.nano' => { :Arch => 'NATHVM64' },
          #:'t2.micro' => { :Arch => 'NATHVM64' },
          # :'t2.small' => { :Arch => 'NATHVM64' },
          # :'t2.medium' => { :Arch => 'NATHVM64' },
          # :'t2.large' => { :Arch => 'NATHVM64' },
          # :'m1.small' => { :Arch => 'NATPV64' },
          # :'m1.medium' => { :Arch => 'NATPV64' },
          # :'m1.large' => { :Arch => 'NATPV64' },
          # :'m1.xlarge' => { :Arch => 'NATPV64' },
          # :'m2.xlarge' => { :Arch => 'NATPV64' },
          # :'m2.2xlarge' => { :Arch => 'NATPV64' },
          # :'m2.4xlarge' => { :Arch => 'NATPV64' },
          # :'m3.medium' => { :Arch => 'NATHVM64' },
          # :'m3.large' => { :Arch => 'NATHVM64' },
          # :'m3.xlarge' => { :Arch => 'NATHVM64' },
          # :'m3.2xlarge' => { :Arch => 'NATHVM64' },
          # :'m4.large' => { :Arch => 'NATHVM64' },
          # :'m4.xlarge' => { :Arch => 'NATHVM64' },
          # :'m4.2xlarge' => { :Arch => 'NATHVM64' },
          # :'m4.4xlarge' => { :Arch => 'NATHVM64' },
          # :'m4.10xlarge' => { :Arch => 'NATHVM64' },
          # :'c1.medium' => { :Arch => 'NATPV64' },
          # :'c1.xlarge' => { :Arch => 'NATPV64' },
          # :'c3.large' => { :Arch => 'NATHVM64' },
          # :'c3.xlarge' => { :Arch => 'NATHVM64' },
          # :'c3.2xlarge' => { :Arch => 'NATHVM64' },
          # :'c3.4xlarge' => { :Arch => 'NATHVM64' },
          # :'c3.8xlarge' => { :Arch => 'NATHVM64' },
          # :'c4.large' => { :Arch => 'NATHVM64' },
          # :'c4.xlarge' => { :Arch => 'NATHVM64' },
          # :'c4.2xlarge' => { :Arch => 'NATHVM64' },
          # :'c4.4xlarge' => { :Arch => 'NATHVM64' },
          # :'c4.8xlarge' => { :Arch => 'NATHVM64' },
          # :'g2.2xlarge' => { :Arch => 'NATHVMG2' },
          # :'g2.8xlarge' => { :Arch => 'NATHVMG2' },
          # :'r3.large' => { :Arch => 'NATHVM64' },
          # :'r3.xlarge' => { :Arch => 'NATHVM64' },
          # :'r3.2xlarge' => { :Arch => 'NATHVM64' },
          # :'r3.4xlarge' => { :Arch => 'NATHVM64' },
          # :'r3.8xlarge' => { :Arch => 'NATHVM64' },
          # :'i2.xlarge' => { :Arch => 'NATHVM64' },
          # :'i2.2xlarge' => { :Arch => 'NATHVM64' },
          # :'i2.4xlarge' => { :Arch => 'NATHVM64' },
          # :'i2.8xlarge' => { :Arch => 'NATHVM64' },
          # :'d2.xlarge' => { :Arch => 'NATHVM64' },
          # :'d2.2xlarge' => { :Arch => 'NATHVM64' },
          # :'d2.4xlarge' => { :Arch => 'NATHVM64' },
          # :'d2.8xlarge' => { :Arch => 'NATHVM64' },
          # :'hi1.4xlarge' => { :Arch => 'NATHVM64' },
          # :'hs1.8xlarge' => { :Arch => 'NATHVM64' },
          # :'cr1.8xlarge' => { :Arch => 'NATHVM64' },
          # :'cc2.8xlarge' => { :Arch => 'NATHVM64' }

  mapping 'AWSRegionArch2AMI',
          # :'us-east-1' => { :PV64 => 'ami-2a69aa47', :HVM64 => 'ami-97785bed', :HVMG2 => 'ami-0a6e3770' },
          # :'us-west-2' => { :PV64 => 'ami-7f77b31f', :HVM64 => 'ami-f2d3638a', :HVMG2 => 'ami-ee15a196' },
          # :'us-west-1' => { :PV64 => 'ami-a2490dc2', :HVM64 => 'ami-824c4ee2', :HVMG2 => 'ami-0da4a46d' },
          # :'eu-west-1' => { :PV64 => 'ami-4cdd453f', :HVM64 => 'ami-d834aba1', :HVMG2 => 'ami-af8013d6' },
          # :'eu-west-2' => { :PV64 => 'NOT_SUPPORTED', :HVM64 => 'ami-403e2524', :HVMG2 => 'NOT_SUPPORTED' },
          # :'eu-west-3' => { :PV64 => 'NOT_SUPPORTED', :HVM64 => 'ami-8ee056f3', :HVMG2 => 'NOT_SUPPORTED' },
          # :'eu-central-1' => { :PV64 => 'ami-6527cf0a', :HVM64 => 'ami-5652ce39', :HVMG2 => 'ami-1d58ca72' },
          # :'ap-northeast-1' => { :PV64 => 'ami-3e42b65f', :HVM64 => 'ami-ceafcba8', :HVMG2 => 'ami-edfd658b' },
          # :'ap-northeast-2' => { :PV64 => 'NOT_SUPPORTED', :HVM64 => 'ami-863090e8', :HVMG2 => 'NOT_SUPPORTED' },
          # :'ap-northeast-3' => { :PV64 => 'NOT_SUPPORTED', :HVM64 => 'ami-83444afe', :HVMG2 => 'NOT_SUPPORTED' },
          # :'ap-southeast-1' => { :PV64 => 'ami-df9e4cbc', :HVM64 => 'ami-68097514', :HVMG2 => 'ami-c06013bc' },
          # :'ap-southeast-2' => { :PV64 => 'ami-63351d00', :HVM64 => 'ami-942dd1f6', :HVMG2 => 'ami-85ef12e7' },
          # :'ap-south-1' => { :PV64 => 'NOT_SUPPORTED', :HVM64 => 'ami-531a4c3c', :HVMG2 => 'ami-411e492e' },
          :'us-east-2' => { :PV64 => 'NOT_SUPPORTED', :HVM64 => 'ami-6a003c0f', :HVMG2 => 'NOT_SUPPORTED' }
          # :'ca-central-1' => { :PV64 => 'NOT_SUPPORTED', :HVM64 => 'ami-a954d1cd', :HVMG2 => 'NOT_SUPPORTED' },
          # :'sa-east-1' => { :PV64 => 'ami-1ad34676', :HVM64 => 'ami-84175ae8', :HVMG2 => 'NOT_SUPPORTED' },
          # :'cn-north-1' => { :PV64 => 'ami-77559f1a', :HVM64 => 'ami-cb19c4a6', :HVMG2 => 'NOT_SUPPORTED' },
          # :'cn-northwest-1' => { :PV64 => 'ami-80707be2', :HVM64 => 'ami-3e60745c', :HVMG2 => 'NOT_SUPPORTED' }

#   resource 'EC2Instance', :Type => 'AWS::EC2::Instance', :Properties => {
#             :InstanceType => ref('InstanceType'),
#             :SecurityGroups => [ ref('SecurityGroup') ],
#             :KeyName => ref('KeyPairName'),
#             :ImageId => find_in_map('AWSRegionArch2AMI', aws_region, find_in_map('AWSInstanceType2Arch', ref('InstanceType'), 'Arch')),
#   }

  resource 'SecurityGroup', :Type => 'AWS::EC2::SecurityGroup', :Properties => {
            :GroupDescription => 'Enable SSH access via port 22',
            :SecurityGroupIngress => [
            {
            :IpProtocol => 'tcp',
            :FromPort => '22',
            :ToPort => '22',
            :CidrIp => ref('SSHLocation'),
            },
      ],
  }


  # Selects all rows in the table which match the name/value pairs of the predicate object and returns a
  # set of nested maps, where the key for the map at level n is the key at index n in the specified keys,
  # except for the last key in the specified keys which is used to determine the value of the leaf-level map.
    text = Table.load 'maps/table.txt'
    mapping 'TableExampleMap',
        text.get_map({ :column0 => 'foo' }, :column1, :column2, :column3)

  # The tag type is a DSL extension; it is not a property of actual CloudFormation templates.
  #   These tags are excised from the template and used to generate a series of --tag arguments
  #   which are passed to CloudFormation when a stack is created.
  #   They do not ultimately appear in the expanded CloudFormation template.
  #   The diff subcommand will compare tags with the running stack and identify any changes,
  #   but a stack update will do the diff and throw an error on any immutable tags update attempt.
  #   The tags are propagated to all resources created by the stack, including the stack itself.
  #   If a resource has its own tag with the same name as CF's it's not overwritten.
  #
  # Amazon has set the following restrictions on CloudFormation tags:
  #   => limit 10
  # CloudFormation tags declaration examples:

  tag 'My:New:Tag',
      :Value => 'ImmutableTagValue',
      :Immutable => true

  tag :MyOtherTag,
      :Value => 'My Value With Spaces'

  tag(:"tag:name", :Value => 'tag_value', :Immutable => true)

  # Following format is deprecated and not advised. Please declare CloudFormation tags as described above.
  #tag :TagName => 'tag_value'    # It's immutable.

        
  resource "ASG", :Type => 'AWS::AutoScaling::AutoScalingGroup', :Properties => {
            :AvailabilityZones => 'us-east-2',
            :HealthCheckType => 'EC2',
            :LaunchConfigurationName => ref('LaunchConfig'),
            :MinSize => 1,
            :MaxSize => 2,
            # :NotificationConfiguration => {
            #     :TopicARN => ref('EmailSNSTopic'),
            #     :NotificationTypes => %w(autoscaling:EC2_INSTANCE_LAUNCH autoscaling:EC2_INSTANCE_LAUNCH_ERROR autoscaling:EC2_INSTANCE_TERMINATE autoscaling:EC2_INSTANCE_TERMINATE_ERROR),
            # },
             :Tags => [
            {
                :Key => 'Name',
                # Grabs a value in an external map file.
                :Value => find_in_map('TableExampleMap', 'corge', 'grault'),
                :PropagateAtLaunch => 'true',
            },
            {
                :Key => 'Label',
                :Value => parameters['Label'],
                :PropagateAtLaunch => 'true',
            }
        ],
  }   



  resource 'WaitConditionHandle', :Type => 'AWS::CloudFormation::WaitConditionHandle', :Properties => {}

  resource 'WaitCondition', :Type => 'AWS::CloudFormation::WaitCondition', :DependsOn => 'ASG', :Properties => {
            :Handle => ref('WaitConditionHandle'),
            :Timeout => 1200,
            :Count => "1"
  }

  resource 'LaunchConfig', :Type => 'AWS::AutoScaling::LaunchConfiguration', :Properties => {
            :ImageId => parameters['ImageId'],
            :KeyName => ref('KeyPairName'),
    #        :IamInstanceProfile => ref('InstanceProfile'),
            :InstanceType => ref('InstanceType'),
            :InstanceMonitoring => 'false',
            :SecurityGroups => [ref('SecurityGroup')],
    # :BlockDeviceMappings => [
    #     {:DeviceName => '/dev/sdb', :VirtualName => 'ephemeral0'},
    #     {:DeviceName => '/dev/sdc', :VirtualName => 'ephemeral1'},
    #     {:DeviceName => '/dev/sdd', :VirtualName => 'ephemeral2'},
    #     {:DeviceName => '/dev/sde', :VirtualName => 'ephemeral3'},
    # ],
    # Loads an external userdata script with an interpolated argument.
            :UserData => base64(interpolate(file('pre_install.sh'), time: Time.now)),
  }

#   output 'InstanceId',
#          :Description => 'InstanceId of the newly created EC2 instance',
#          :Value => ref('EC2Instance')

#   output 'AZ',
#          :Description => 'Availability Zone of the newly created EC2 instance',
#          :Value => get_att('EC2Instance', 'AvailabilityZone')

#   output 'PublicDNS',
#          :Description => 'Public DNSName of the newly created EC2 instance',
#          :Value => get_att('EC2Instance', 'PublicDnsName')

#   output 'PublicIP',
#          :Description => 'Public IP address of the newly created EC2 instance',
#          :Value => get_att('EC2Instance', 'PublicIp')

end.exec!
