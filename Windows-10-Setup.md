# Instructions on setting up Windows 10 hosts in Users VLAN and joining to the Domain

### If you haven't setup the Domain Controller and DNS Server yet, go back and do that before setting up the Windows hosts.

### ***Put ESXI Install Instructions and initial install instructions***

Windows 10 Pro Key: `W269N-WFGWX-YVC9B-4J6C9-T83GX`

<u>To join the host to our domain</u>

1. Change Computer Name

Set the computer name to match the machine we are installing (reference the IP address list). For example, if we were installing Win1.

- Type computer name into the search bar

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%209.52.21%20AM.png?raw=true)

- Select **Rename this PC**

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%209.54.12%20AM.png?raw=true)

- Change the PC name as shown and click **Restart** to apply the changes.

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%209.54.47%20AM.png?raw=true)

2. Once the Host has restarted we need to update the IP address information.

- Navigate to Control Panel

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%2010.01.40%20AM.png?raw=true)

- Click on **Network and Internet** -> **Network and Sharing** -> **Change Adapter Options**

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%2010.03.39%20AM.png?raw=true)
![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%2010.03.54%20AM.png?raw=true)

- Right click on the adapter and select **Properties**. Deselect IPv6, select IPv4 and select **Properties** and set the IP configuraiton to match the below (change the IP address to match the host you're installing. Reference the IP address list.)

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%2010.04.16%20AM.png?raw=true)
![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%2010.06.05%20AM.png?raw=true)

- Select **Ok** and **Close**

3. Join the host to our domain

    1. Navigate to System and Security, and then click System.

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%2010.11.51%20AM.png?raw=true)

    2. Under Computer name, domain, and workgroup settings, click **Change settings**.

    3. Scroll to the bottom and click **Advanced Settings**

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%2010.12.45%20AM.png?raw=true)

    3. Under the Computer Name tab, click **Change**.

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%2010.13.20%20AM.png?raw=true)

    4. Under Member of, click Domain, type the name of the our avengers domain, and then click **OK**.

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%2010.14.13%20AM.png?raw=true)

    5. Type the credentials of the domain admin

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%2010.15.02%20AM.png?raw=true)

    - You should now see "welcome to the avengers.lan domain"

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-18%20at%2010.15.24%20AM.png?raw=true)

    5. Restart the computer.