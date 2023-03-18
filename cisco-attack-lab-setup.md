# How to configure attack lab Cisco switch

## ***This was generated by ChatGPT4 and has not been validated yet on our hardware***

To reset a Cisco 2960-XR 48 port switch to default configuration, follow these steps:

1.Connect to the switch using a console cable and a terminal emulator, like PuTTY or Tera Term.

2.Power on the switch and press the "Mode" button on the front panel of the switch to enter ROMmon mode.

3. At the ROMmon prompt, enter the following command to erase the startup-config:

```
flash_init
delete flash:/config.text
```

4. Restart the switch with the following command:

```
boot
```
5. After the switch boots up, you will be prompted to enter the initial configuration dialog. Type **"no"** and press **Enter**.


Now, to set up 3 VLANs (VLAN 10, 20, and 30), configure the Layer 3 switch to route between VLANs, and create a SPAN port on port 48 that mirrors traffic from all VLAN 10 and 20 ports, follow these steps:

1. Enter global configuration mode:

```
enable
configure terminal
```
2. Create VLANs 10, 20, and 30:

```
vlan 10
 name VLAN10
 exit

vlan 20
 name VLAN20
 exit

vlan 30
 name VLAN30
 exit
```

3. Assign switch ports to the appropriate VLANs (ports 1-12 for VLAN 10, 13-24 for VLAN 20, and 25-36 for VLAN 30):

```
interface range GigabitEthernet1/0/1-12
 switchport mode access
 switchport access vlan 10
 exit

interface range GigabitEthernet1/0/13-24
 switchport mode access
 switchport access vlan 20
 exit

interface range GigabitEthernet1/0/25-36
 switchport mode access
 switchport access vlan 30
 exit
```

4. Configure inter-VLAN routing by creating Switch Virtual Interfaces (SVIs) for each VLAN:

```
interface Vlan10
 ip address 192.168.10.1 255.255.255.0
 no shutdown
 exit

interface Vlan20
 ip address 192.168.20.1 255.255.255.0
 no shutdown
 exit

interface Vlan30
 ip address 192.168.30.1 255.255.255.0
 no shutdown
 exit
```

5. Enable IP routing on the switch:

```
ip routing
```

6. Create a SPAN port on port 48 that mirrors traffic from all VLAN 10 and 20 ports:

```
monitor session 1 source vlan 10 , 20 both
monitor session 1 destination interface GigabitEthernet1/0/48
```

7. Save the configuration:

```
write memory
```

Now the Cisco 2960-XR switch is configured with the default configuration, 3 VLANs, inter-VLAN routing, and a SPAN port on port 48.