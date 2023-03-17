# <u> User VLAN Windows Domain Setup</u>

## ***<b><u>Put ESXI Windows VM setup instructions</u></b>***

Install standard datacenter (desktop experience). Your install will initally be an evaluation edition.

Open a command prompt as administrator and type the following command to upgrade your server from the evaluation license:

```
DISM /online /Set-Edition:ServerStandard /ProductKey:77KDY-N2CQ8-JVWH3-8GXTV-462HP /AcceptEula

Do you want to restart(Y/n): Y  #To restart
```

<u>Installing Windows Domain Controller and DNS Server</u>

1. Change Computer Name
    - Type "Computer Name" in the start bar and click "View your PC Name"
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%205.41.11%20PM.png?raw=true)
    - Select "Rename PC"
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%205.41.21%20PM.png?raw=true)
    - Rename the server to "DC" as shown.
    - Restart to apply the changes
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%205.41.34%20PM.png?raw=true)