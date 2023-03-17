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

2. Install Domain Controller and DNS
    1. In Server Manager, click **Manage** and click **Add Roles and Features** to start the Add Roles Wizard.

    2. On the Before you begin page, click Next.

    3. On the Select installation type page, click **Role-based** and then click **Next**.

    4. On the Select destination server page, click Select a server from the server pool, click the name of the server where you want to install AD DS and then click Next.

    6. On the Select server roles page, click Active Directory Domain Services, then on the Add Roles and Features Wizard dialog box, click Add Features, and then click Next.

    7. On the Select features page, select any additional features you want to install and click Next.

    8. On the Active Directory Domain Services page, review the information and then click Next.

    9. On the Confirm installation selections page, click Install.

    10. On the Results page, verify that the installation succeeded, and click Promote this server to a domain controller to start the Active Directory Domain Services Configuration Wizard.

