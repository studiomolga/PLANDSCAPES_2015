# PLANDSCAPES_2015

PLANDSCAPES 2015 revived

KIT
1) Sensors (arduino, ethernet shields)
2) electrodes (which one do we have?)
3) usb A to B arduino cables
4) Network Switch
5) Ethernet cables
6) Computer (IOS, Windows, Rasp)
7) Monitors


EXHIBITION

1) Plants with big and thick enough leaves to be able to take an electrode
2) Space to place the electronics around in safe, dry way
3) Prints - a hanging system to display a number of A3 prints

SETUP

1) <strong>FOR MAC OS:</strong> install <strong>mosquitto</strong> on <strong>only ONE</strong> of the minimac, follow this: https://subscription.packtpub.com/book/application-development/9781787287815/1/ch01lvl1sec12/installing-a-mosquitto-broker-on-macos.  
(you might need to install a <strong>homebrew</strong> https://brew.sh/ for this - and be patient! It takes time)

2) make sure <strong>mosquitto</strong> starts automatically - if not - make sure you start it on the main computer (the one with the ip address 198.168.1.1 in each terminal with this line: 

/usr/local/sbin/mosquitto -c /usr/local/etc/mosquitto/mosquitto.conf

3) Set up local network - every one of this mac shall get a static IP address for each of minimacs: (MAIN) 192.168.1.1 (for the one with runninh mosquitto), 192.168.1.4 and 192.168.1.5

4) Router / gateway for all of them shall be 192.168.1.1 (as the first mac on which the mosquitto is running), netmask shall be 255.255.255.0

5) Install Processing on all computers 

6) Downaload Vocabulary of Plants_01, Plant_02 and Plant_03 to respective computers (01 to the first, 02 to second, 03 to third)
- [plant01](https://github.com/studiomolga/PLANDSCAPES_2015/releases/tag/plant_1_probe_0)
- [plant02](https://github.com/studiomolga/PLANDSCAPES_2015/releases/tag/plant_1_probe_1)
- [plant03](https://github.com/studiomolga/PLANDSCAPES_2015/releases/tag/plant_2_probe_0)


7) Download libraries to all the computers (and place it in the <i>libraries</i> folder of <i>Processing</i> folder - usually placed in <i>documents</i>)


8) SENSORS - one board can be connected to two plant (photo?) because we can connect two sensors to one board
Then sensors are connected to switch, and switch to computer(s). 

Connect electrodes to the Arduino and shield (photo?), connect shield to the switch, put arduino on...
Do they need to get some ip addresses or whatever? 

9) run the processing sketch on each computer (are we actually having it as app or they just run fill screen sketch?)
wait for the first signal to see the visualisation - you might need to do it every morning before the opening time. 

each visualisation will be saved as pdf in the folder ....

10) IMPORTANT! Resolution of the monitor is has to be set 768 x 1024. - the monitor will be set HORIZONTALLY so that mac needs to know that 768 is a width, and 1024 is a heigth

11) SENSORS - ground in the soil then red and blue on the plant (conductive gel)
12) PDFs are saved in the folder "namename" located in the Vocabulary of plants folder....
