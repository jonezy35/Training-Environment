# Instructions on setting up Windows 10 hosts in Users VLAN and joining to the Domain

### If you haven't setup the Domain Controller and DNS Server yet, go back and do that before setting up the Windows hosts.

### ***Put ESXI Install Instructionss***

## <b><u>Install</u></b>

Once you load the VM and start it, if you see the below screen, you need to press "Send CTRL+ALT+DEL" and wait for the prompt "press any key to boot from CD or DVD". Once you see that prompt, press any key to boot into the ISO.

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.23.43%20PM.png?raw=true)

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.23.58%20PM.png?raw=true)

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.24.45%20PM.png?raw=true)

Work through the installer as normal, and when asked for a key input the one below:

Windows 10 Pro Key: `W269N-WFGWX-YVC9B-4J6C9-T83GX`

Choose Custom Install

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%201.28.33%20PM.png?raw=true)

Finish working through the installer as normal.

Select **i don't have internet** -> **continue with limited setup** -> and create our dmss user.

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%203.29.58%20PM.png?raw=true)

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%203.30.09%20PM.png?raw=true)

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%203.30.26%20PM.png?raw=true)

Deselect all privacy settings

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%203.32.35%20PM.png?raw=true)

Select **not now** for cortana

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%203.32.53%20PM.png?raw=true)



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


    You should now be able to sign in as any one of the domain users

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%203.45.32%20PM.png?raw=true)


    ### Connecting the Mail client to our Exchange Server

    Ensure you have already finished the Exchange Server Setup SOP

    1. Open your mail client, click **Add an Account** and scroll down to click on **Advanced Setup**

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-20%20at%2011.48.28%20AM.png?raw=true)

    2. Click **Exchange ActiveSync** 

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-20%20at%2011.48.33%20AM.png?raw=true)

    3. Enter the following information, changing the account information depending on the account you're setting up.

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-20%20at%2011.49.15%20AM.png?raw=true)

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-20%20at%2011.49.20%20AM.png?raw=true)

    4. Your email account is now setup, and you can send a test email to yourself or to another account to verify. It may take a little bit for the email to send from the outbox since this is teh first time we're sending an email. You may also have to accept the insecure ssl pop up.

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-20%20at%2011.49.56%20AM.png?raw=true)

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-20%20at%2011.50.21%20AM.png?raw=true)

    5. After a bit, our email should send and appear in our inbox!

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-20%20at%2011.51.21%20AM.png?raw=true)

    6. Go over each of these steps for all users.