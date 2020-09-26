# eja-docker-freeswitch
My take on setting up a dockerized FreeSwitch
<br>
__Danger__ repo created for dev and learning purpsoes only ^^
<hr>

## How to run
Run the **install.sh** script, and optionally pass the image and container 
names (__-i__ and __-c__, defaults to _freeswitch:eja_ and _freeswitcheja_) <br>
<code>./install.sh -i freeswitch:imgver01 -c freeswitchContainer01</code>
## How to configure
Dockerfile will copy any configuration dirs/files from __config__, into 
__/etc/freeswitch__.

#### Mounts
install.sh will create a dir, __"mounts"__, within this repo's working directory.
Mounts that you can use for live changing FreeSwitch configs:
* volumes/etc/freeswitch
* volumes/usr/share/freeswitch

#### Refresh config changes within mounts
Upon changing any mounted FreeSwitch configuration, simply run __fs-reloadxml.sh__,
or __fs-restart.sh__. The first will simply issue the __reloadxml__ command
within via FreeSwitch CLI, while the latter will restart the entire FS service within
the container.

<hr>

##### Refs; Honors; Links
* [FS Confluence](https://freeswitch.org/confluence/)
* Tuzla Voice Team's repo [RTC-TP](https://git.ib-ci.com/projects/RTC-TP)
* My [Github](https://github.com/eldarj/docker-freeswitch) 

## TODOS
-[x] add install.sh
-[ ] add fs-reloadxml.sh
-[ ] add fs-restart.sh 
