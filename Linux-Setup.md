# Settin up Linux VM's

### These are the directions for setting up any of our Linux VM's so that we can later install the services we need.


First we need to manually set our IP address. Using nmtui, you can edit your IP address via GUI. 

`sudo su`

`nmtui`

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.09.23%20PM.png?raw=true)

Select our interface

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.09.29%20PM.png?raw=true)

Change the mode to **manual** and referecing the IP address list, edit the settings to match below:

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.09.39%20PM.png?raw=true)

- <u>IP Address</u>: The IP of the machine you're installing
- <u>Gateway</u>: 10.10.10.1
- <u>DNS Servers</u>: 10.10.10.50

To force the interface to load the new IP address, go to **activate a connection** and toggle the interface off and back on again.

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.11.04%20PM.png?raw=true)

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.11.07%20PM.png?raw=true)

Exit nmtui by hitting **Ok** at the bottom. You can now check that your IP address was updated with `nmcli`

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.11.15%20PM.png?raw=true)

Test your connection to the DNS server

```
ping repo.dmss.lan
```

We now need to configure our VM to use our offline repository.

```
mv /etc/yum.repos.d/*.repo /tmp/
```

```
cd /etc/yum.repos.d/
```

```
curl -L -O http://repo.dmss.lan/localrepo.repo
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
cd /home/dmss

curl -L -O http://repo.dmss.lan/install.sh
```

Let's now execute our install script.

```
chmod 777 install.sh

./install.sh
```