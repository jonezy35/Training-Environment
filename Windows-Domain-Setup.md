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

2. Set static IP Address
    - Navigate to adapter options
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.30.25%20PM.png?raw=true)
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.30.31%20PM.png?raw=true)
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.30.38%20PM.png?raw=true)

    - Deselect IPv6. Right click IPv4 and navigate to Properties
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.30.51%20PM.png?raw=true)
    - Set the IPv4 settings as shown in the picture below:
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.34.49%20PM.png?raw=true)

    - Press OK and Close.

3. Install Domain Controller and DNS
    1. In Server Manager, click **Manage** and click **Add Roles and Features** to start the Add Roles Wizard.
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.47.57%20PM.png?raw=true)

    2. On the Before you begin page, click **Next**.

    3. On the Select installation type page, click **Role-based** and then click **Next**.
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.48.06%20PM.png?raw=true)
    4. On the Select destination server page, click on the DC (the local server we are on) and then click **Next**.
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.54.15%20PM.png?raw=true)

    6. On the Select server roles page, click Active Directory Domain Services and DNS Server, then on the **Add Roles and Features** Wizard dialog box, click **Add Features**, and then click **Next**.
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.54.30%20PM.png?raw=true)

    7. On the Select features page, leave it as default and click **Next**.
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.54.47%20PM.png?raw=true)

    9. On the Confirm installation selections page, click Install.
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.55.01%20PM.png?raw=true)

    10. On the Results page, verify that the installation succeeded, and click Promote this server to a domain controller to start the Active Directory Domain Services Configuration Wizard.

