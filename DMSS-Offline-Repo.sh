#######This script should be run with sudo and will automatically create the DMSS offline repository

#!/bin/bash

# Import RPM GPG key
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

# Install nginx
dnf install nginx -y
systemctl enable nginx

# Setup extra repositories
dnf config-manager --set-enabled crb
dnf install epel-release -y
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Needed Dependencies
sudo dnf install tar -y
sudo dnf install htop -y
sudo dnf install git -y
sudo dnf install vim -y
sudo dnf install wget -y
sudo dnf install bind bind-utils -y
sudo dnf install docker-ce docker-ce-cli containerd.io -y

# Create Local Repository
dnf install yum-utils -y
mkdir /usr/share/nginx/html/repos
mkdir -p /usr/share/nginx/html/repos/{baseos,appstream,crb,epel,elastic,extras,zeek,suricata,docker-ce-stable}

# Verify repositories have been enabled successfully
#dnf repolist

# Clone repositories
dnf reposync -g --delete -p /usr/share/nginx/html/repos/ --repoid=appstream --newest-only --download-metadata
dnf reposync -g --delete -p /usr/share/nginx/html/repos/ --repoid=baseos --newest-only --download-metadata
dnf reposync -g --delete -p /usr/share/nginx/html/repos/ --repoid=crb --newest-only --download-metadata
dnf reposync -p /usr/share/nginx/html/repos/ --repoid=epel --newest-only --download-metadata
dnf reposync -g --delete -p /usr/share/nginx/html/repos/ --repoid=extras --newest-only --download-metadata
dnf reposync --delete -p /usr/share/nginx/html/repos/ --repoid=docker-ce-stable --newest-only --download-metadata

# Download non repository dependencies

# Zeek
cd /usr/share/nginx/html/repos/zeek
git clone --recurse-submodules https://github.com/zeek/zeek zeek
tar -cvzf zeek.tar.gz zeek

# Suricata
cd /usr/share/nginx/html/repos/suricata
curl -L -O https://www.openinfosecfoundation.org/download/suricata-6.0.10.tar.gz

# Elastic Stack
cd /usr/share/nginx/html/repos/elastic
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.9-x86_64.rpm
wget https://artifacts.elastic.co/downloads/kibana/kibana-7.17.9-x86_64.rpm
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.17.9-x86_64.rpm
curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.17.9-x86_64.rpm
curl -L -O https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-7.17.9-windows-x86_64.zip
curl -L -O https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-7.17.9-windows-x86_64.msi
curl -L -O https://artifacts.elastic.co/downloads/logstash/logstash-7.17.9-x86_64.rpm

# Set hostname

hostnamectl set-hostname repo.dmss.lan

# Start the DNS server

systemctl enable --now named

