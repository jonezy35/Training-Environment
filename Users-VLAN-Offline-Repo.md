# Insructions on how to setup offline repository VM on Users VLAN

### ***This assumes you have already followed the offline repository creation SOP***

`sudo su`

`hostnamectl set-hostname repo.avengers.lan`

## ***Set IP Address to 192.168.10.75***

We need to manually set our IP address. Using nmtui, you can edit your IP address via GUI. 

`nmtui`

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.09.23%20PM.png?raw=true)

Select our interface

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.09.29%20PM.png?raw=true)

Change the mode to **manual** and referecing the IP address list, edit the settings to match below:

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.09.39%20PM.png?raw=true)

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.10.47%20PM.png?raw=true)

To force the interface to load the new IP address, go to **activate a connection** and toggle the interface off and back on again.

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.11.04%20PM.png?raw=true)

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.11.07%20PM.png?raw=true)

Exit nmtui by hitting **Ok** at the bottom. You can now check that your IP address was updated with `nmcli`

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.11.15%20PM.png?raw=true)

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.11.23%20PM.png?raw=true)

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