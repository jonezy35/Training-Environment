# This script should be run as sudo and will automatically create the Users-Vlan-Offline-Repo

#!/bin/bash

echo " "
echo -e "This script \033[4mMUST\033[0m be run with sudo permissions"
echo " "
echo "You need an internet connection to create the offline repository"
echo " "
echo "If you're unsure how to get an internet connection, refer to the offline repository SOP for instructions"
echo " "
echo "This script will automatically start in 30 seconds..."

countdown=30
while [ \$countdown -gt 0 ]; do
  printf "\rCountdown: %2d seconds remaining" \$countdown
  sleep 1
  countdown=\$((countdown - 1))
done

# Import RPM GPG key
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

# Setup extra repositories
sudo dnf config-manager --set-enabled crb
sudo dnf install epel-release -y
sudo dnf clean all

# Install dependencies
sudo dnf install tar -y
sudo dnf install htop -y
sudo dnf install git -y
sudo dnf install vim -y
sudo dnf install wget -y

# Install nginx to serve our files
dnf install nginx -y
systemctl enable nginx --now

# Download Windows Active Directory Dependencies
sudo mkdir -p /usr/share/nginx/html/repos/windows
cd /usr/share/nginx/html/repos/windows

echo "DISM /online /Set-Edition:ServerStandard /ProductKey:77KDY-N2CQ8-JVWH3-8GXTV-462HP /AcceptEula" > server_upgrade.txt

curl -L -O https://download.microsoft.com/download/2/5/8/258D30CF-CA4C-433A-A618-FB7E6BCC4EEE/ExchangeServer2016-x64-cu12.iso

curl -L https://go.microsoft.com/fwlink/?LinkID=2099383 --output net-installer.exe
curl -L -O https://download.microsoft.com/download/2/C/4/2C47A5C1-A1F3-4843-B9FE-84C0032C61EC/UcmaRuntimeSetup.exe
curl -L -O https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe
wget https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/0ac7e1bd-ebbe-4895-8694-1952a345a987/MicrosoftEdgeEnterpriseX64.msi

# Set hostname
hostnamectl set-hostname repo.avengers.lan

# Create nginx config file so windows machines can connect.

filename="/etc/nginx/conf.d/repos.conf"

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

sudo firewall-cmd --add-port 80/tcp --permanent
sudo firewall-cmd --reload

sudo systemctl restart nginx

echo "nginx configured"
echo "firewall rules added"
echo "Users VLAN offline repository ready"