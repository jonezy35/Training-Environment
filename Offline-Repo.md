# <u>Instructions on creating offline DNF repository</u>

## Add Laptop & VMWare Workstation Pro setup


### Need at least 50Gb free storage

<u>Switch to root</u>

`sudo su`


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
dnf install bind bind-utils -y
dnf install docker-ce docker-ce-cli containerd.io -y
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

These commands will take awhile to run, and tend to hang before they finish. Don't worry if the command hangs after completing.
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

wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.9-x86_64.rpm

wget https://artifacts.elastic.co/downloads/kibana/kibana-7.10.2-x86_64.rpm

curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.10.2-x86_64.rpm

curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.10.2-x86_64.rpm

curl -L -O https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-7.10.2-windows-x86_64.zip

curl -L -O https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-7.10.2-windows-x86_64.msi

curl -L -O https://artifacts.elastic.co/downloads/logstash/logstash-7.10.2-x86_64.rpm
```

## <u>Download Windows Active Directory Dependencies</u>

```
mkdir /usr/share/nginx/html/repos/windows
```

```
cd /usr/share/nginx/html/repos/windows

echo "DISM /online /Set-Edition:ServerStandard /ProductKey:77KDY-N2CQ8-JVWH3-8GXTV-462HP /AcceptEula" > server_upgrade.txt

curl -L -O https://download.microsoft.com/download/2/5/8/258D30CF-CA4C-433A-A618-FB7E6BCC4EEE/ExchangeServer2016-x64-cu12.iso
```

```
curl -L https://go.microsoft.com/fwlink/?LinkID=2099383 --output net-installer.exe
```
```
curl -L -O https://download.microsoft.com/download/2/C/4/2C47A5C1-A1F3-4843-B9FE-84C0032C61EC/UcmaRuntimeSetup.exe
```

```
curl -L -O https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe
```

```
wget https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/0ac7e1bd-ebbe-4895-8694-1952a345a987/MicrosoftEdgeEnterpriseX64.msi
```

We are now finished downloading all of the required repositories/ dependencies. For security reasons, you should now remove the wireless NIC from the laptop to airgap our system from the internet.

You can now upload this VM to the Users VLAN on the attack lab server and follow the Users-Vlan-Offline-Repo SOP. 

For the DMSS offline repo, upload this VM to the DMSS server and follow the DMSS-Offline-Repo SOP.

