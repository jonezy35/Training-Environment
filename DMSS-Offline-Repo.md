# Follow this guide after finishing the offline repo SOP to setup the DMSS repo VM.

`sudo su`

```
hostnamectl set-hostname repo.dmss.lan
```

## ***Add set IP Address section***

### <u>Configure DNS server on repo VM</u>

```
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
```

The spacing should look like this:

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.16.41%20PM.png?raw=true)

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

```
firewall-cmd --add-port 80/tcp --permanent
firewall-cmd --reload
firewall-cmd --list-all  #Check to ensure port 80 was added
```

`systemctl restart nginx`

### Create offline repo config to copy over to our other workstations:

On repo.dmss.lan VM:

```
sudo su
```

```
mv /etc/yum.repos.d/*.repo /tmp/
```

```
vim /etc/yum.repos.d/localrepo.repo
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

### ***Add portion on setting up second linux server and copying over the repo information***

Copy the localrepo.repo file to our nginx share so we can access it with other VM's

```
cp /etc/yum.repos.d/localrepo.repo /usr/share/nginx/html/repos/
```

Let's now create a bash script to install all of the dependencies we will need for our sensor.

```
vim /usr/share/nginx/html/repos/install.sh
```

Copy and paste the below into your install.sh file:

```
#!/bin/bash

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
#sudo dnf install libpcre3 libpcre3-dbg libpcre3-dev build-essential libpcap-dev  -y \
#                libnet1-dev libyaml-0-2 libyaml-dev pkg-config zlib1g zlib1g-dev -y \
#                libcap-ng-dev libcap-ng0 make libmagic-dev -y        \
#                libnss3-dev libgeoip-dev liblua5.1-dev libhiredis-dev libevent-dev -y \
#                python-yaml rustc cargo -y
#
echo "All dependencies are now installed"

echo "All dependencies are now installed"
```