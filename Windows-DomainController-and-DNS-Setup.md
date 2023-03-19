# <u> Users VLAN Windows Domain Controller & DNS Setup</u>

### <u>***NOTE</u>: In order to test the DNS setup below, you need to have already setup the Users VLAN offline repository (linux) VM***

## <b><u>Install</u></b>

Once you load the VM and start it, if you see the below screen, you need to press "Send CTRL+ALT+DEL" and wait for the prompt "press any key to boot from CD or DVD". Once you see that prompt, press any key to boot into the ISO.

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.23.43%20PM.png?raw=true)

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.23.58%20PM.png?raw=true)

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.24.45%20PM.png?raw=true)

Work through the installer as normal, and ensure to select Windows Server 2016 Standard Evaluation (Desktop Experience) when prompted.

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.27.43%20PM.png?raw=true)

Choose Custom Install

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.28.33%20PM.png?raw=true)

Set the default administrator password

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.38.27%20PM.png?raw=true)


#### Our server install is currently in evaluation mode. To upgrade from evaluation, we need to run a simple command with our product key. We will grab this command from our repo VM.

- Set static IP Address
    - Navigate to adapter options
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.30.25%20PM.png?raw=true)
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.30.31%20PM.png?raw=true)
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.30.38%20PM.png?raw=true)

    - Deselect IPv6. Right click IPv4 and navigate to Properties
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.30.51%20PM.png?raw=true)
    - Set the IPv4 settings as shown in the picture below:
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.34.49%20PM.png?raw=true)

    - Press **OK** and **Close**.

We now need to reach out to the repository to grab our license information. We haven't setup DNS yet, so we will navigate to the repo by ip.

Install standard datacenter (desktop experience). Your install will initally be an evaluation edition.

Open the browser and navigate to http://192.168.10.75

Select windows

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.43.43%20PM.png?raw=true)

Select server_upgrade.txt

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.43.53%20PM.png?raw=true)

Open a command prompt as administrator and copy the following command from your browser to upgrade your server from the evaluation license:

```
DISM /online /Set-Edition:ServerStandard /ProductKey:77KDY-N2CQ8-JVWH3-8GXTV-462HP /AcceptEula
```

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.45.21%20PM.png?raw=true)

```
Do You Want To Restart The Computer Now? (Y/N) Y  #To restart
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

3. Install Domain Controller and DNS
    1. In Server Manager, click **Manage** and click **Add Roles and Features** to start the Add Roles Wizard.
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.47.57%20PM.png?raw=true)

    2. On the Before you begin page, click **Next**.

    3. On the Select installation type page, click **Role-based** and then click **Next**.
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.48.06%20PM.png?raw=true)
    4. On the Select destination server page, click on the DC (the local server we are on) and then click **Next**.
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.54.15%20PM.png?raw=true)

    6. On the Select server roles page, click **Active Directory Domain Services** and **DNS Server**, then on the Add Roles and Features Wizard dialog box, click **Add Features**, and then click **Next**.
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.54.30%20PM.png?raw=true)

    7. On the Select features page, leave it as default and click **Next**.
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.54.47%20PM.png?raw=true)

    9. On the Confirm installation selections page, click **Install**.
    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-17%20at%206.55.01%20PM.png?raw=true)

    10. On the Results page, verify that the installation succeeded, and click **Promote this server to a domain controller** to start the Active Directory Domain Services Configuration Wizard.

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%208.22.55%20AM.png?raw=true)

    11. Select **add a new forest** and create the root domain name as "avengers.lan". Click **Next**

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%208.23.38%20AM.png?raw=true)

    12. Leave all options as default on the domain contoller options page, input our default password, and select **Next**

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%208.26.37%20AM.png?raw=true)

    13. On the DNS Options page, leave the defaults and click **Next**

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%208.26.46%20AM.png?raw=true)
    
    14. The wizard should automatically recognize our netbios name. Click **Next**.

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%208.27.31%20AM.png?raw=true)

    15. Leave the default paths and click **Next**

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%208.27.59%20AM.png?raw=true)

    16. Click **Next** on the reviw options page.

    17. Click **Install**

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%208.29.31%20AM.png?raw=true)


## <u> Adding DNS entries</u>

Once the server restarts, we need to login and add our DNS entries.

1. Click on **Tools** -> **DNS**

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%208.41.07%20AM.png?raw=true)

2. Click on **DC** -> **Forward Lookup Zones** -> **AVENGERS.lan**

3. Right click the empty white space and choose **New Host (A or AAA)**

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%208.42.33%20AM.png?raw=true)

4. Add our offline repository

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%208.45.06%20AM.png?raw=true)

5. If your DNS entry was successful, you should now be able to navigate to the repo.avengers.lan webpage.

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%208.47.48%20AM.png?raw=true)

6. Continue adding all static DNS A record entries so that our DNS server has all hosts added from the attached IP address list for the Users VLAN.


To keep us up to date, let's now install microsoft edge.

Navigate to the windows folder on repo.avengers.lan and download the Microsoft Edge msi

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%202.46.26%20PM.png?raw=true)

You may have to add the site as a trusted site if you get a pop up error.

Save the file and when it's downloaded, right click the file and choose **Install**.

Once it's installed, there will be an edge icon on your desktop (sometimes you may need to logout and sign back in). You can now pin edge to your taskbar and remove internet explorer.

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%202.54.00%20PM.png?raw=true)

## ***Add section about adding user accounts***

## <u>Adding Domain Accounts</u>

1. In server manager, click on **Tools** -> **Active Directory Users and Computers**

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%202.55.47%20PM.png?raw=true)

2. Click on **avengers.lan** -> **Users** -> and click on the icon in the image below to add a user.

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%202.56.37%20PM.png?raw=true)

3. Add all users from the Users list provided, and ensure you check **password never expires**

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%202.58.32%20PM.png?raw=true)

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%202.58.49%20PM.png?raw=true)
