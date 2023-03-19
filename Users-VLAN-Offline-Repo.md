# Insructions on how to setup offline repository VM on Users VLAN

### ***This assumes you have already followed the offline repository creation SOP***

`sudo su`

`hostnamectl set-hostname repo.avengers.lan`

## ***Set IP Address to 192.168.10.75***



<u>Setup Nginx web server</u>

The nginx web server will serve the offline repository to other offline boxes. (We installed nginx at the beginning so we don't need to do that now)

```
vim /etc/nginx/conf.d/repos.conf
```

Paste the following into your repos.conf file

```
server {
        listen   80;
        server_name  repo.avengers.lan;
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

Once we setup our DNS entries on the domain controller, you should be able to navigate to http://repo.avengers.lan