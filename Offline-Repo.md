# <u>Instructions on creating offline DNF repository</u>

### Need at least 50Gb free storage

<u>Switch to root</u>

`sudo su`

```
hostnamectl set-hostname repo.dmss.lan
```

<u>Import RPM GPG key</u>

`rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org`

<u>Install nginx</u>

`dnf install nginx -y`

`systemctl enable nginx`

<u>Setup extra repositories</u>
```
dnf config-manager --set-enabled crb

dnf install epel-release -y

dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```
<u> Install Needed Dependencies</u>
```
sudo dnf install tar -y
sudo dnf install htop -y
sudo dnf install git -y
sudo dnf install vim -y 
sudo dnf install wget -y
dnf install docker-ce docker-ce-cli containerd.io
```

<u>Create Local Repository</u>
```
dnf install yum-utils -y

mkdir /usr/share/nginx/html/repos

mkdir -p /usr/share/nginx/html/repos/{baseos,appstream,crb,epel,elastic,extras,zeek,suricata,docker-ce-stable}
```

<u>Verify repositories have been enabled successfully</u>

`dnf repolist` 

you should see something like this:

```
repo id                                                             repo name
appstream                                                           AlmaLinux 9 - AppStream
baseos                                                              AlmaLinux 9 - BaseOS
crb                                                                 AlmaLinux 9 - CRB
docker-ce-stable                                                    Docker CE Stable - x86_64
epel                                                                Extra Packages for Enterprise Linux 9 - x86_64
extras                                                              AlmaLinux 9 - Extras
```

<u>Clone repositories</u>
```
dnf reposync -g --delete -p /usr/share/nginx/html/repos/ --repoid=appstream --newest-only --download-metadata

dnf reposync -g --delete -p /usr/share/nginx/html/repos/ --repoid=baseos --newest-only --download-metadata

dnf reposync -g --delete -p /usr/share/nginx/html/repos/ --repoid=crb --newest-only --download-metadata

dnf reposync -p /usr/share/nginx/html/repos/ --repoid=epel --newest-only --download-metadata

dnf reposync -g --delete -p /usr/share/nginx/html/repos/ --repoid=extras --newest-only --download-metadata

dnf reposync --delete -p /usr/share/nginx/html/repos/ --repoid=docker-ce-stable --newest-only --download-metadata
```

<u>Download non repository dependencies</u>

Zeek
```
cd /usr/share/nginx/html/repos/zeek

git clone --recurse-submodules https://github.com/zeek/zeek
```

Suricata
```
cd /usr/share/nginx/html/repos/suricata

curl -L -O https://www.openinfosecfoundation.org/download/suricata-6.0.10.tar.gz
```

Elastic Stack

```
cd /usr/share/nginx/html/repos/elastic

wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.10.2-x86_64.rpm

wget https://artifacts.elastic.co/downloads/kibana/kibana-7.10.2-x86_64.rpm

curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.10.2-x86_64.rpm

curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.10.2-x86_64.rpm

curl -L -O https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-7.10.2-windows-x86_64.zip

curl -L -O https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-7.10.2-windows-x86_64.msi
```

### <u>Install and Configure DNS server on repo VM</u>

```
dnf install bind bind-utils -y
systemctl enable --now named

systemctl status named  #Check to ensure it started with no errors
```
```
cp /etc/named.conf /etc/named.conf.orig

vim /etc/named.conf
```
Set the following in your named.conf

```
acl internal {
	192.168.10.0/24;
        localhost;
        localnets;
};

options {
        listen-on port 53 { 192.168.10.50; };
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
```

<u>Setup DNS Addresses</u>
```
vim /var/named/dmss.lan.zone
```

Copy and paste the below into your dmss.lan.zone file (ensure the spacing is correct after pasting as it can get messed up sometimes)

```
$TTL 2d
$ORIGIN dmss.lan.

@           IN      SOA     ns.dmss.lan admin.dmss.lan (
                                20230218		; serial number
		                        3600			; refresh period
		                        600			    ; retry period
		                        604800			; expire time
		                        1800 			; negative TTL
                                )
@           IN      NS      ns.dmss.lan.

ns          IN      A       192.168.10.50

; Internal Boxes
win1        IN      A       192.168.10.10
win2        IN      A       192.168.10.11
alma        IN      A       192.168.10.12

; Internal Services
repo        IN      CNAME   ns
es1         IN      A       192.168.10.100
es2         IN      A       192.168.10.101
es3         IN      A       192.168.10.102
kb          IN      A       192.168.10.103
sensor      IN      A       192.168.10.104
```

The spacing should look like this:

![image](https://github.com/jonezy35/Training-Environment/blob/main/Screenshot%202023-03-17%20at%205.37.07%20AM.png?raw=true)

```
chown root:named /etc/named.conf
chown -R named:named /var/named
chmod 644 /etc/named.conf
chmod 644 /var/named/dmss.lan.zone
```

```
firewall-cmd --add-port 53/udp --permanent
firewall-cmd --reload
firewall-cmd --list-all  #Check to ensure port 53 was added
```
<u>Setup Nginx web server</u>

The nginx web server will serve the offline repository to other offline boxes. (We installed nginx at the beginning so we don't need to do that now)

```
vim /etc/nginx/conf.d/repos.conf
```

Paste the following into your repos.conf file

```
server {
        listen   80;
        server_name  repo.dmss.lan;
        root   /usr/share/nginx/html/repos;
	index index.html; 
	location / {
                autoindex on;
        }
}
```

<u>Configuring other Linux workstations to access the repository</u>

Sign in and switch to sudo
```
sudo su
```

```
mv /etc/yum.repos.d/*.repo /tmp/
```

```
vi /etc/yum.repos.d/localrepo.repo
```

Copy and paste the below into your localrepo.repo

```
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
baseurl=http://repo.dmss.lan/appstream/
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
```

```
dnf clean all

dnf repolist
```

You should now see something similar to the below

```
repo id                                                                         repo name
localrepo-appstream                                                             AlmaLinux AppStream
localrepo-base                                                                  AlmaLinux Base
localrepo-crb                                                                   AlmaLinux CodeReadBuilder
localrepo-epel                                                                  AlmaLinux EPEL
localrepo-extras                                                                AlmaLinux Extras
```

You can now test your offline repositories by installing a package

```
dnf install vim -y
```

You can now install the other basic dependencies needed

```
sudo dnf install tar -y
sudo dnf install htop -y
sudo dnf install git -y
sudo dnf install vim -y 
sudo dnf install wget -y
```