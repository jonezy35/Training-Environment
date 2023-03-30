#!/bin/bash

# Switch to root
#sudo su

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
dnf install bind bind-utils -y
dnf install docker-ce docker-ce-cli containerd.io -y

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

# Download Windows Active Directory Dependencies
mkdir /usr/share/nginx/html/repos/windows
cd /usr/share/nginx/html/repos/windows

echo "DISM /online /Set-Edition:ServerStandard /ProductKey:77KDY-N2CQ8-JVWH3-8GXTV-462HP /AcceptEula" > server_upgrade.txt

curl -L -O https://download.microsoft.com/download/2/5/8/258D30CF-CA4C-433A-A618-FB7E6BCC4EEE/ExchangeServer2016-x64-cu12.iso

curl -L https://go.microsoft.com/fwlink/?LinkID=2099383 --output net-installer.exe
curl -L -O https://download.microsoft.com/download/2/C/4/2C47A5C1-A1F3-4843-B9FE-84C0032C61EC/UcmaRuntimeSetup.exe
curl -L -O https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe
wget https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/0ac7e1bd-ebbe-4895-8694-1952a345a987/MicrosoftEdgeEnterpriseX64.msi

echo "We are now finished downloading all of the required repositories/ dependencies. For security reasons, you should now remove the wireless NIC from the laptop to airgap our system from the internet."

echo "You can now upload this VM to the Users VLAN on the attack lab server and follow the Users-Vlan-Offline-Repo SOP."

echo "For the DMSS offline repo, upload this VM to the DMSS server and follow the DMSS-Offline-Repo SOP."