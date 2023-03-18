# Installing Exchange Server

### ***<u>Note</u>: This must be completed after you setup the Users VLAN offline repo VM and the Domain Controller/DNS***

## ***<b><u>Put ESXI Windows VM setup instructions</u></b>***

Install standard datacenter (desktop experience). Your install will initally be an evaluation edition. We are going to set the IP address information and grab our Windows Server license key from our repository VM.

***ADD IP ADDRESS SETUP AND GRABBING PRODUCT KEY FROM THE REPO***

Open a command prompt as administrator and copy the following command from the repo webpage to upgrade your server from the evaluation license:

```
DISM /online /Set-Edition:ServerStandard /ProductKey:77KDY-N2CQ8-JVWH3-8GXTV-462HP /AcceptEula

Do You Want To Restart The Computer Now? (Y/N): Y  #To restart
```

***Change Computer Name***

***Join Domain***