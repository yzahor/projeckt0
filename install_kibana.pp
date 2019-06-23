#Add Kibana repository
yumrepo { "kibana-6.x":
  baseurl => "https://artifacts.elastic.co/packages/6.x/yum",
  descr => "Kibana repository for 6.x packages",
  enabled => 1,
  gpgcheck => true,
  gpgkey => 'https://packages.elastic.co/GPG-KEY-elasticsearch',
  target => '/etc/yum.repos.d/kibana-6.x.repo',
}  

# execute 'yum update'
exec { 'yum update':                    # exec resource named 'yum update'
  command => '/usr/bin/yum update'  # command this resource will run
}

# install Java package
package { 'java-1.8.0-openjdk.x86_64':
  require => Exec['yum update'],        # require 'yum update' before installing
  ensure => installed,
}

# install Kibana package
package { 'kibana':
  require => Exec['yum update'],        # require 'yum update' before installing
  ensure => installed,
}

# ensure Kibana service is running
service { 'kibana':
  ensure => running,
}

#Install Augeas
package { 'augeas':
  require => Exec['yum update'],        # require 'yum update' before installing
  ensure => installed,
}

#Add Nginx repository
yumrepo { "epel-relise":
  baseurl => "https://dl.fedoraproject.org/pub/epel/7/x86_64/",
  descr => "EPEL repository",
  enabled => 1,
  gpgcheck => true,
  gpgkey => 'https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7'
  target => '/etc/yum.repos.d/epel-relise.repo',
} 

# install Nginx package
package { 'nginx':
  require => Exec['yum update'],        # require 'yum update' before installing
  ensure => installed,
}

# install httpd-tools package
package { 'httpd-tools':
  require => Exec['yum update'],        # require 'yum update' before installing
  ensure => installed,
}

# ensure Kibana service is running
service { 'nginx':
  ensure => running,
}