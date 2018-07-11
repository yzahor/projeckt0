#!/usr/bin/env ruby

require 'bundler/setup'
require 'cloudformation-ruby-dsl/cfntemplate'
require 'cloudformation-ruby-dsl/spotprice'
require 'cloudformation-ruby-dsl/table'

template do

  value :AWSTemplateFormatVersion => '2010-09-09'

  value :Description => 'AWS CloudFormation Sample Template EC2InstanceWithSecurityGroupSample: Create an Amazon EC2 instance running the Amazon Linux AMI. The AMI is chosen based on the region in which the stack is run. This example creates an EC2 security group for the instance to give you SSH access. **WARNING** This template creates an Amazon EC2 instance. You will be billed for the AWS resources used if you create a stack from this template.'

#############################################################################
  parameter 'DBName',
            :Default => 'MyDatabase',
            :Description => 'MySQL database name',
            :Type => 'String',
            :MinLength => '1',
            :MaxLength => '64',
            :AllowedPattern => '[a-zA-Z][a-zA-Z0-9]*',
            :ConstraintDescription => 'must begin with a letter and contain only alphanumeric characters.'

  parameter 'DBUser',
            :NoEcho => 'true',
            :Description => 'Username for MySQL database access',
            :Type => 'String',
            :MinLength => '1',
            :MaxLength => '16',
            :AllowedPattern => '[a-zA-Z][a-zA-Z0-9]*',
            :ConstraintDescription => 'must begin with a letter and contain only alphanumeric characters.',
            :Default => 'MyUser'

  parameter 'DBPassword',
            :NoEcho => 'true',
            :Description => 'Password for MySQL database access',
            :Type => 'String',
            :MinLength => '1',
            :MaxLength => '41',
            :AllowedPattern => '[a-zA-Z0-9]*',
            :ConstraintDescription => 'must contain only alphanumeric characters.',
            :Default => 'MyPassword'

  parameter 'DBRootPassword',
            :NoEcho => 'true',
            :Description => 'Root password for MySQL',
            :Type => 'String',
            :MinLength => '1',
            :MaxLength => '41',
            :AllowedPattern => '[a-zA-Z0-9]*',
            :ConstraintDescription => 'must contain only alphanumeric characters.',
            :Default => 'MyRootPassword'

############################################################################################
  
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
            :Default => 'ami-40142d25',
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
            # :'c1.medium' => { :Arch => 'PV64' },
            # :'c1.xlarge' => { :Arch => 'PV64' },
            # :'c3.large' => { :Arch => 'HVM64' },
            # :'c3.xlarge' => { :Arch => 'HVM64' },
            # :'c3.2xlarge' => { :Arch => 'HVM64' },
            # :'c3.4xlarge' => { :Arch => 'HVM64' },
            # :'c3.8xlarge' => { :Arch => 'HVM64' },
            # :'c4.large' => { :Arch => 'HVM64' },
            # :'c4.xlarge' => { :Arch => 'HVM64' },
            # :'c4.2xlarge' => { :Arch => 'HVM64' },
            # :'c4.4xlarge' => { :Arch => 'HVM64' },
            # :'c4.8xlarge' => { :Arch => 'HVM64' },
            # :'g2.2xlarge' => { :Arch => 'HVMG2' },
            # :'g2.8xlarge' => { :Arch => 'HVMG2' },
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
            :'us-east-2' => { :PV64 => 'NOT_SUPPORTED', :HVM64 => 'ami-40142d25', :HVMG2 => 'NOT_SUPPORTED' }
            # :'ca-central-1' => { :PV64 => 'NOT_SUPPORTED', :HVM64 => 'ami-a954d1cd', :HVMG2 => 'NOT_SUPPORTED' },
            # :'sa-east-1' => { :PV64 => 'ami-1ad34676', :HVM64 => 'ami-84175ae8', :HVMG2 => 'NOT_SUPPORTED' },
            # :'cn-north-1' => { :PV64 => 'ami-77559f1a', :HVM64 => 'ami-cb19c4a6', :HVMG2 => 'NOT_SUPPORTED' },
            # :'cn-northwest-1' => { :PV64 => 'ami-80707be2', :HVM64 => 'ami-3e60745c', :HVMG2 => 'NOT_SUPPORTED' }
  
  resource 'KibanaEC2Instance', :Type => 'AWS::EC2::Instance', 
        :Metadata => { :'AWS::CloudFormation::Init' => { :configSets => { :InstallAndRun => [ 'Install', 'Configure' ] }, 
                                                         :Install => { :packages => { :yum => { :mysql => [], :'mysql-server' => [], :'mysql-libs' => [], :httpd => [], :php => [], :'php-mysql' => [] } }, 
                                                                       :files => { :'/var/www/html/index.php' => { :content => join('', "<html>\n", "  <head>\n", "    <title>AWS CloudFormation PHP Sample</title>\n", "    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=ISO-8859-1\">\n", "  </head>\n", "  <body>\n", "    <h1>Welcome to the AWS CloudFormation PHP Sample</h1>\n", "    <p/>\n", "    <?php\n", "      // Print out the current data and time\n", "      print \"The Current Date and Time is: <br/>\";\n", "      print date(\"g:i A l, F j Y.\");\n", "    ?>\n", "    <p/>\n", "    <?php\n", "      // Setup a handle for CURL\n", "      $curl_handle=curl_init();\n", "      curl_setopt($curl_handle,CURLOPT_CONNECTTIMEOUT,2);\n", "      curl_setopt($curl_handle,CURLOPT_RETURNTRANSFER,1);\n", "      // Get the hostname of the intance from the instance metadata\n", "      curl_setopt($curl_handle,CURLOPT_URL,'http://169.254.169.254/latest/meta-data/public-hostname');\n", "      $hostname = curl_exec($curl_handle);\n", "      if (empty($hostname))\n", "      {\n", "        print \"Sorry, for some reason, we got no hostname back <br />\";\n", "      }\n", "      else\n", "      {\n", "        print \"Server = \" . $hostname . \"<br />\";\n", "      }\n", "      // Get the instance-id of the intance from the instance metadata\n", "      curl_setopt($curl_handle,CURLOPT_URL,'http://169.254.169.254/latest/meta-data/instance-id');\n", "      $instanceid = curl_exec($curl_handle);\n", "      if (empty($instanceid))\n", "      {\n", "        print \"Sorry, for some reason, we got no instance id back <br />\";\n", "      }\n", "      else\n", "      {\n", "        print \"EC2 instance-id = \" . $instanceid . \"<br />\";\n", "      }\n", "      $Database   = \"localhost\";\n", '      $DBUser     = "', ref('DBUser'), "\";\n", '      $DBPassword = "', ref('DBPassword'), "\";\n", "      print \"Database = \" . $Database . \"<br />\";\n", "      $dbconnection = mysql_connect($Database, $DBUser, $DBPassword)\n", "                      or die(\"Could not connect: \" . mysql_error());\n", "      print (\"Connected to $Database successfully\");\n", "      mysql_close($dbconnection);\n", "    ?>\n", "    <h2>PHP Information</h2>\n", "    <p/>\n", "    <?php\n", "      phpinfo();\n", "    ?>\n", "  </body>\n", "</html>\n"), :mode => '000600', :owner => 'apache', :group => 'apache' }, 
                                                                                    :'/tmp/setup.mysql' => { 
                                                                                        :content => join('', 'CREATE DATABASE ', ref('DBName'), ";\n", 'GRANT ALL ON ', ref('DBName'), '.* TO \'', ref('DBUser'), '\'@localhost IDENTIFIED BY \'', ref('DBPassword'), "';\n"), 
                                                                                        :mode => '000400', 
                                                                                        :owner => 'root', 
                                                                                        :group => 'root' 
                                                                                    }, 
                                                                                    :'/etc/cfn/cfn-hup.conf' => { 
                                                                                        :content => join('', "[main]\n", 'stack=', aws_stack_id, "\n", 'region=', aws_region, "\n"), 
                                                                                        :mode => '000400', 
                                                                                        :owner => 'root', 
                                                                                        :group => 'root' 
                                                                                    }, 
                                                                                    :'/etc/cfn/hooks.d/cfn-auto-reloader.conf' => { 
                                                                                        :content => join('', "[cfn-auto-reloader-hook]\n", "triggers=post.update\n", "path=Resources.KibanaEC2Instance.Metadata.AWS::CloudFormation::Init\n", 'action=/opt/aws/bin/cfn-init -v ', '         --stack ', aws_stack_name, '         --resource KibanaEC2Instance ', '         --configsets InstallAndRun ', '         --region ', aws_region, "\n", "runas=root\n"), 
                                                                                        :mode => '000400', 
                                                                                        :owner => 'root', 
                                                                                        :group => 'root' 
                                                                                        } 
                                                                                    }, 
                                                                       :services => { :sysvinit => { 
                                                                            :mysqld => { :enabled => 'true', :ensureRunning => 'true' }, 
                                                                            :httpd => { :enabled => 'true', :ensureRunning => 'true' }, 
                                                                            :'cfn-hup' => { :enabled => 'true', :ensureRunning => 'true', 
                                                                                :files => [ '/etc/cfn/cfn-hup.conf', '/etc/cfn/hooks.d/cfn-auto-reloader.conf' ] 
                                                                            } 
                                                                        }
                                                                        }
                                                        }, 
                                                         :Configure => { :commands => { 
                                                                            :'01_set_mysql_root_password' => { 
                                                                                :command => join('', 'mysqladmin -u root password \'', ref('DBRootPassword'), '\''), 
                                                                                :test => join('', '$(mysql ', ref('DBName'), ' -u root --password=\'', ref('DBRootPassword'), '\' >/dev/null 2>&1 </dev/null); (( $? != 0 ))') }, 
                                                                            :'02_create_database' => { 
                                                                                :command => join('', 'mysql -u root --password=\'', ref('DBRootPassword'), '\' < /tmp/setup.mysql'), 
                                                                                :test => join('', '$(mysql ', ref('DBName'), ' -u root --password=\'', ref('DBRootPassword'), '\' >/dev/null 2>&1 </dev/null); (( $? != 0 ))') } } } } }, 
        :CreationPolicy => { :ResourceSignal => { :Timeout => 'PT5M' } },
        :Properties => {
            :InstanceType => ref('InstanceType'),
            :SecurityGroups => [ ref('SecurityGroup') ],
            :KeyName => ref('KeyPairName'),
            :ImageId => find_in_map('AWSRegionArch2AMI', aws_region, find_in_map('AWSInstanceType2Arch', ref('InstanceType'), 'Arch')),
            :UserData => base64(
                join('',
                     "#!/bin/bash -xe\n",
                     "yum update -y aws-cfn-bootstrap\n",
                     "# Install the files and packages from the metadata\n",
                     '/opt/aws/bin/cfn-init -v ',
                     '         --stack ', aws_stack_name,
                     '         --resource KibanaEC2Instance ',
                     '         --configsets InstallAndRun ',
                     '         --region ', aws_region,"\n",
                     "# Signal the status from cfn-init\n",
                     '/opt/aws/bin/cfn-signal -e $? ',
                     '         --stack ', aws_stack_name,
                     '         --resource KibanaEC2Instance ',
                     '         --region ', aws_region,"\n",
                )
            ),
  }

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


#   resource 'SecurityGroup', :Type => 'AWS::EC2::SecurityGroup', :Properties => {
#     :GroupDescription => 'Lets any vpc traffic in.',
#     :SecurityGroupIngress => {:IpProtocol => '-1', :FromPort => '0', :ToPort => '65535', :CidrIp => "10.0.0.0/8"}
# }

        
  resource "ASGKibana", :Type => 'AWS::AutoScaling::AutoScalingGroup', :Properties => {
            :AvailabilityZones => ['us-east-2a'],
            :HealthCheckType => 'EC2',
            #:InstanceID => ref('KibanaEC2Instance'),
            #:KeyName => ref('KeyPairName'),
            :LaunchConfigurationName => ref('LaunchConfigKBN'),
            :MinSize => 1,
            :MaxSize => 5,
            :NotificationConfiguration => {
                :TopicARN => ref('EmailSNSTopic'),
                :NotificationTypes => %w(autoscaling:EC2_INSTANCE_LAUNCH autoscaling:EC2_INSTANCE_LAUNCH_ERROR autoscaling:EC2_INSTANCE_TERMINATE autoscaling:EC2_INSTANCE_TERMINATE_ERROR),
            },
             :Tags => [
            {
                :Key => 'Name',
                # Grabs a value in an external map file.
                #:Value => find_in_map('TableExampleMap', 'corge', 'grault'),
                :Value => 'Kibana',
                :PropagateAtLaunch => 'true',
            },
            {
                :Key => 'Label',
                :Value => parameters['Label'],
                :PropagateAtLaunch => 'true',
            }
        ],
  }   

  resource "ASGElasticsearch", :Type => 'AWS::AutoScaling::AutoScalingGroup', :Properties => {
            :AvailabilityZones => ['us-east-2a'],
            :HealthCheckType => 'EC2',
            #:InstanceID => ref('KibanaEC2Instance'),
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
                # Grabs a value in an external map file.
                #:Value => find_in_map('TableExampleMap', 'corge', 'grault'),
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
            #:Endpoint => ref('EmailAddress'),
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

  resource 'LaunchConfigKBN', :Type => 'AWS::AutoScaling::LaunchConfiguration', :Properties => {
            :ImageId => 'ami-40142d25',
            #:ImageId => find_in_map('AWSRegionArch2AMI', aws_region, find_in_map('AWSInstanceType2Arch', ref('InstanceType'), 'Arch')),
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
            #:UserData => base64(interpolate(file('preinstall.sh'), time: Time.now)),
            
    }

  resource 'LaunchConfigELS', :Type => 'AWS::AutoScaling::LaunchConfiguration', :Properties => {
            :ImageId => 'ami-40142d25',
            #:ImageId => find_in_map('AWSRegionArch2AMI', aws_region, find_in_map('AWSInstanceType2Arch', ref('InstanceType'), 'Arch')),
            #:InstanceID => ref('KibanaEC2Instance'),
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
            :UserData => base64(interpolate(file('preinstall.sh'), time: Time.now)),
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
