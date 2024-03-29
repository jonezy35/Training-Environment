# Building our DMSS kit sensor

### You must first follow the Linux-Setup SOP


Change to root to complete this setup

`sudo su`

### Installing Dependencies

`add section on downloading dependencies script from repo`

### Building Zeek

Let us first pull the zeek source code from our repository

```
wget http://repo.dmss.lan/zeek/zeek.tar.gz
tar xzvf zeek.tar.gz
cd zeek
```

We now need to build zeek from source. You can run `./configure` and it will work, but we're going to do a little configuration first.


`./configure --prefix=/opt/zeek --localstatedir=/var/log/zeek --conf-files-dir=/etc/zeek --disable-spicy`

`make`    #This may take a few hours. You can speed this up by adding a `-j#` where `#` is the number of CPU cores you want to give to make. for example `make -j8` would use 8 CPU cores in parallel to speed things up.

`make install`

#### Some explanation of what the above commands do (straight from Google):
1. `./configure` This command runs a script named configure that is included with many software packages. The configure script checks your system for the necessary libraries, headers, and other dependencies required by the software, and generates a Makefile that can be used to build the software. The ./ before the command name is used to specify that the script is located in the current directory.
2. `make` This command reads the Makefile generated by the configure script and builds the software according to the instructions in the Makefile. It compiles the source code files, links them together, and creates executable programs or shared libraries.
3. `make install` This command installs the compiled software onto your system. It copies the executable programs, shared libraries, and other files to the appropriate directories on your system so that they can be run or used by other software. The installation process usually requires root privileges, so you may need to run this command with sudo or as the root user.

Now that zeek is installed, we can add the zeek binary directory to the path of our dmss user (that way we can run commands without having to give the full path of the command)

```
vim /home/dmss/.bashrc
```

Add the below to the end of the .bashrc file:
```
export PATH="$PATH:/opt/zeek/bin"
```

To apply the changes immediately for the dmss user, run:
```
su dmss 
source ~/.bashrc
```

### Building Suricata

We will need to switch back to root for this:

`sudo su`

First we need to pull the suricata source code from our repository.

```
wget http://repo.dmss.lan/suricata/suricata-6.0.10.tar.gz

tar xzvf suricata-6.0.10.tar.gz

cd suricata-6.0.10
```

Just like with zeek above, we must create the make file and then install Suricata.
```
./configure --prefix=/opt/suricata --enable-lua --enable-geoip --localstatedir=/var --sysconfdir=/etc --disable-gccmarch-native --enable-profiling --enable-http2-decompression --enable-python --enable-af-packet

make

make install-full
```

### Installing Filebeat

```
mkdir filebeat
cd filebeat
curl -L -O http://repo.dmss.lan/elastic/filebeat-7.17.9-x86_64rpm

rpm -vi filebeat-7.17.9-x86_64 
```

Filebeat is now installed.

### Configuring the Sensor