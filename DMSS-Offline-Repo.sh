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

sudo hostnamectl set-hostname repo.dmss.lan

# Start the DNS server

sudo systemctl enable --now named

sudo cp /etc/named.conf /etc/named.conf.old

# Create custom named.conf 

filename="/etc/named.conf"

sudo cat > "$filename" << EOF
acl internal {
	10.10.10.0/24;
        localhost;
        localnets;
};

options {
        listen-on port 53 { 10.10.10.50; };
        listen-on-v6 port 53 { ::1; };
        directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        secroots-file   "/var/named/data/named.secroots";
        recursing-file  "/var/named/data/named.recursing";
        allow-query     { internal; };

        recursion no;

        dnssec-validation yes;

        managed-keys-directory "/var/named/dynamic";
        geoip-directory "/usr/share/GeoIP";

        pid-file "/run/named/named.pid";
        session-keyfile "/run/named/session.key";

        include "/etc/crypto-policies/back-ends/bind.config";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "dmss.lan" IN {
    type master;
    file "/var/named/dmss.lan.zone";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
EOF

echo "New named.conf created"


# Create our dns zone file

filename1="/var/named/dmss.lan.zone"

sudo cat > "$filename1" << EOF
\$TTL 2d
\$ORIGIN dmss.lan.

@           IN      SOA     ns.dmss.lan admin.dmss.lan (
                                20230218		; serial number
		                        3600			; refresh period
		                        600			    ; retry period
		                        604800			; expire time
		                        1800 			; negative TTL
                                )
@           IN      NS      ns.dmss.lan.

ns          IN      A       10.10.10.50

; Internal Boxes
win1        IN      A       10.10.10.10
win2        IN      A       10.10.10.11
alma        IN      A       10.10.10.12

; Internal Services
repo        IN      CNAME   ns
es1         IN      A       10.10.10.100
es2         IN      A       10.10.10.101
es3         IN      A       10.10.10.102
kb          IN      A       10.10.10.103
sensor      IN      A       10.10.10.104
EOF

echo "dmss zone file created"


# Fix permissions for our DNS files
sudo chown root:named /etc/named.conf
sudo chown -R named:named /var/named
sudo chmod 644 /etc/named.conf
sudo chmod 644 /var/named/dmss.lan.zone

# Add required ports for our DNS server
sudo firewall-cmd --add-port 53/udp --permanent
sudo firewall-cmd --reload

# Restart our DNS server so the changes can take effect
sudo systemctl restart named



# Setup NGINX web server

filename2="/etc/nginx/conf.d/repos.conf"

sudo cat > "$filename2" << EOF
server {
        listen   80;
        server_name  repo.dmss.lan;
        root   /usr/share/nginx/html/repos;
	index index.html; 
	location / {
                autoindex on;
        }
}
EOF

echo "Nginx server configured"



# Add firewall rules for nginx server
sudo firewall-cmd --add-port 80/tcp --permanent
sudo firewall-cmd --reload



#Restart nginx so teh changes can take effect
sudo systemctl restart nginx



# Create offline repo config to copy over to our other workstations
sudo mv /etc/yum.repos.d/*.repo /tmp/

filename3="/etc/yum.repos.d/localrepo.repo"
sudo cat > "$filename3" << EOF
[localrepo-base]
name=AlmaLinux Base
baseurl=http://repo.dmss.lan/baseos/
gpgcheck=0
enabled=1

[localrepo-appstream]
name=AlmaLinux AppStream
baseurl=http://repo.dmss.lan/appstream/
gpgcheck=0
enabled=1

[localrepo-crb]
name=AlmaLinux CodeReadBuilder
baseurl=http://repo.dmss.lan/crb/
gpgcheck=0
enabled=1

[localrepo-epel]
name=AlmaLinux EPEL
baseurl=http://repo.dmss.lan/epel/
gpgcheck=0
enabled=1

[localrepo-extras]
name=AlmaLinux Extras
baseurl=http://repo.dmss.lan/extras/
gpgcheck=0
enabled=1
EOF

sudo dnf clean all

sudo cp /etc/yum.repos.d/localrepo.repo /usr/share/nginx/html/repos/

echo "localrepo's configured"



# Create Sensor Install bash script so the sensor VM can pull it down instead of having to recreate it.

filename4="/usr/share/nginx/html/repos/sensor-install.sh"

sudo cat > "$filename4" << EOF
#!/bin/bash

echo " "
echo -e "This script \033[4mMUST\033[0m be run as root"
echo " "
echo "This script may take a few hours to run."
echo " "
echo "This script will automatically start in 30 seconds..."

countdown=30
while [ \$countdown -gt 0 ]; do
  printf "\rCountdown: %2d seconds remaining" \$countdown
  sleep 1
  countdown=\$((countdown - 1))
done

echo " "
echo "Starting Script..."

#Configure offline repo
sudo mv /etc/yum.repos.d/*.repo /tmp/

sudo curl -L -o /etc/yum.repos.d/localrepo.repo http://repo.dmss.lan/localrepo.repo

sudo dnf clean all

#Update packages
sudo dnf update -y

#Install needed dependencies
sudo dnf install tar -y
sudo dnf install htop -y
sudo dnf install git -y
sudo dnf install vim -y
sudo dnf install wget -y
sudo dnf install util-linux-user -y
sudo dnf install net-tools -y
sudo dnf install unzip -y

#Install needed zeek dependencies
sudo dnf install cmake -y
sudo dnf install make -y
sudo dnf install gcc -y 
sudo dnf install gcc-c++ -y 
sudo dnf install flex -y 
sudo dnf install bison -y 
sudo dnf install libpcap-devel -y
sudo dnf install openssl-devel -y
sudo dnf install python3 -y
sudo dnf install python3-devel -y
sudo dnf install swig -y 
sudo dnf install zlib-devel -y

#Install needed suricata dependencies
sudo dnf install pcre-devel -y
sudo dnf install libyaml-devel -y
sudo dnf install jansson-devel -y
sudo dnf install lua-devel -y
sudo dnf install file-devel -y
sudo dnf install nspr-devel -y
sudo dnf install nss-devel -y
sudo dnf install libcap-ng-devel -y
sudo dnf install libmaxminddb-devel -y
sudo dnf install lz4-devel -y
sudo dnf install rustc cargo -y
sudo dnf install python3-pyyaml -y

# Pull down zeek
wget http://repo.dmss.lan/zeek/zeek.tar.gz
tar xzvf zeek.tar.gz
cd zeek

# Install Zeek

./configure --prefix=/opt/zeek --localstatedir=/var/log/zeek --conf-files-dir=/etc/zeek --disable-spicy
make
make install

# Pull down Suricata

wget http://repo.dmss.lan/suricata/suricata-6.0.10.tar.gz
tar xzvf suricata-6.0.10.tar.gz
cd suricata-6.0.10

# Install Suricata

./configure --prefix=/opt/suricata --enable-lua --enable-geoip --localstatedir=/var --sysconfdir=/etc --disable-gccmarch-native --enable-profiling --enable-http2-decompression --enable-python --enable-af-packet
make
make install-full

# Install Filebeat

mkdir filebeat
cd filebeat
curl -L -O http://repo.dmss.lan/elastic/filebeat-7.17.9-x86_64rpm
rpm -vi filebeat-7.17.9-x86_64 

echo "All dependencies are now installed"
echo " "
echo "We can now configure the Sensor"
EOF

echo "Sensor install bash script has been created"
echo " "
echo " "
echo "The DMSS offline repository has been configured."

