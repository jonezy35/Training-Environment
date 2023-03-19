# Installing Exchange Server

### ***<u>Note</u>: This must be completed after you setup the Users VLAN offline repo VM and the Domain Controller/DNS***

## ***<b><u>Put ESXI Windows VM setup instructions</u></b>***

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
    - Set the IPv4 settings as:
        - IP Address: 192.168.10.51
        - Subnet Mask: 255.255.255.0
        - Default Gateway: 192.168.10.1
        - DNS Server: 192.168.10.50

    - Press **OK** and **Close**.

    - If prompted, select **Yes**

    ![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%204.13.50%20PM.png?raw=true)

Open the browser and navigate to http://repo.avengers.lan

Select windows

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%204.14.49%20PM.png?raw=true)

Select server_upgrade.txt

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%204.14.59%20PM.png?raw=true)

Open a command prompt as administrator and copy the following command from your browser to upgrade your server from the evaluation license:

```
DISM /online /Set-Edition:ServerStandard /ProductKey:77KDY-N2CQ8-JVWH3-8GXTV-462HP /AcceptEula
```

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%204.15.47%20PM.png?raw=true)

```
Do You Want To Restart The Computer Now? (Y/N) Y  #To restart
```

### Change Computer Name and Join Domain

1. Navigate to **control panel** -> **System and Security** -> **System** and click **Change Settings**

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%204.25.09%20PM.png?raw=true)

2. Under the Computer Name tab, select **Change**

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%204.26.47%20PM.png?raw=true)

3. Change the Computer Name to "Exchange" and the domain to "avengers.lan"

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%204.27.36%20PM.png?raw=true)

4. Enter the domain administrator credentials

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%204.28.19%20PM.png?raw=true)

You should now see a welcome to the domain pop up:

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%204.28.26%20PM.png?raw=true)

Restart the server

You should now login as the domain administrator to continuse configuring the server.

![image](https://github.com/jonezy35/Training-Environment/blob/main/images/Screenshot%202023-03-19%20at%204.31.34%20PM.png?raw=true)

***Install Microsoft Edge***


***Grab and install prerequisites (.NET may take awhile to install)***

***Exchange Server Install (May take a few hours)***