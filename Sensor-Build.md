# Building our DMSS kit sensor

### You must first follow the Linux-Setup SOP.

`sudo su`

### Building Zeek

Let us first pull the zeek source code from our repository (Don't forget the forward slash after zeek, otherwise it will pull the whole repo.dmss.lan page)

```
wget --no-parent -r http://repo.dmss.lan/zeek/

cd repo.dmss.lan/zeek/zeek/
```

We now need to build zeek from souce (check to make sure configure is executable. If not change it to executable with `chmod 777 configure`)

```
./configure --prefix=/opt/zeek --localstatedir=/var/log/zeek --conf-files-dir=/etc/zeek --disable-spicy 
```