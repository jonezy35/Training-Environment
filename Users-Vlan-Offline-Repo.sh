# This script should be run as sudo and will automatically create the Users-Vlan-Offline-Repo

#!/bin/bash

# Install nginx
sudo dnf install tar -y
sudo dnf install htop -y
sudo dnf install git -y
sudo dnf install vim -y
sudo dnf install wget -y
dnf install nginx -y
systemctl enable nginx --now

# Download Windows Active Directory Dependencies
mkdir /usr/share/nginx/html/repos/windows
cd /usr/share/nginx/html/repos/windows

echo "DISM /online /Set-Edition:ServerStandard /ProductKey:77KDY-N2CQ8-JVWH3-8GXTV-462HP /AcceptEula" > server_upgrade.txt

curl -L -O https://download.microsoft.com/download/2/5/8/258D30CF-CA4C-433A-A618-FB7E6BCC4EEE/ExchangeServer2016-x64-cu12.iso

curl -L https://go.microsoft.com/fwlink/?LinkID=2099383 --output net-installer.exe
curl -L -O https://download.microsoft.com/download/2/C/4/2C47A5C1-A1F3-4843-B9FE-84C0032C61EC/UcmaRuntimeSetup.exe
curl -L -O https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe
wget https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/0ac7e1bd-ebbe-4895-8694-1952a345a987/MicrosoftEdgeEnterpriseX64.msi

# Create nginx config file so windows machines can connect.

filename="/etc/nvinx/conf.d/repos.conf"

sudo cat > "$filename" << EOF
server {
        listen   80;
        server_name  repo.avengers.lan;
        root   /usr/share/nginx/html/repos;
	index index.html; 
	location / {
                autoindex on;
        }
}
EOF

firewall-cmd --add-port 80/tcp --permanent
firewall-cmd --reload

systemctl restart nginx

echo "nginx configured"
echo "firewall rules added"
echo "Users VLAN offline repository ready"