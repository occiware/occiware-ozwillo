# NodeMCU subproject

## Introduction

This folder contains all the sources required to flash the NodeMCU device with the OCCIware LDaaS demo code. This code has two purposes :

+ Generate mock energy consumption data,

+ Connect to a local WI-FI network and then to the demo Blynk server to regularly send it the mock energy consumption data.

## A note on Blynk

The NodeMCU communicates with a distant Blynk server that is on the Ozwillo Demo VM. To access its admin interface, simply connect to the Ozwillo VPN and go to: https://10.28.7.17:9443/admin (user/pass admin@blynk.cc/admin).

To configure the Blynk project, you have to use the Blynk Android App, since the Config tab at the bottom of the Blynk server does not work. For explanations on how to use it, please go to: http://docs.blynk.cc/ and look up instructions for "custom" or "local" server rather than the Blynk cloud.

> **IMPORTANT NOTE**: IF YOU EVER REMOVE AND RECREATE THE IMPORT-SERVER-1 DOCKER CONTAINER ON THE OZWILLO VM, ALL AUTH TOKENS WILL BE LOST, AND YOU'LL HAVE TO USE THE APP TO REGENERATE ONE, THEN REFLASH THE NODEMCU WITH IT.

Here are the required steps for that :
- install the Blynk Android app from the Play store, in login screen provide same credentials (admin@blynk.cc/admin) AND click on the options button to provide custom local server's public IP
- then create "occiware-ozwillo" project for an ESP8266 device, and generate an auth token
- get the token in the admin web UI at https://10.28.7.17:9443/admin#/users/edit/admin@blynk.cc-Blynk
- in Atom IDE, write it in the nodemcu/main.cpp code
- and using Platform IO extension compile it, then upload it on the device (that must have been plugged through USB, and serial enabled)
- then see below "Using the NodeMCU".


## Prerequisites

In order to manipulate this code, you will need to install the [PlatformIO IDE for Atom](http://platformio.org/platformio-ide). Follow the instructions given in the previous link, and if you are using a GNU/Linux distribution, **don't forget to execute the following command to allow access to serial, and then reboot your computer**:

```bash
sudo usermod -a -G dialout $USER
sudo reboot
```

## Running the code

Once you have completed the prerequisites, all you have to is: Open Atom > Click on the PlatformIO tab in the top of the window > Open project folder... > and select this "nodemcu" folder the README.md is in. Then open the main.cpp file click on the "PlatformIO: Upload" button in the top-left corner of the window.

## Using the NodeMCU

If you simply want to use the device, you only need to plug it to a USB power source.

However, since the connection to the WIFI network is hardcoded here for the sake of simplicity, if you don't want to reflash the device with specific credentials, you may generate the WIFI network from your computer's ethernet interface following these simple steps (require a GNU/Linux distribution):

1. Clone the "create_ap" repository from Github to a place of your choosing, and install the following packages:

    ```bash
    git clone https://github.com/oblique/create_ap
    sudo apt-get install hostapd haveged dnsmasq
    ```

2. Check what are the names of your network interfaces :

    ```bash
    ifconfig
    ```

3. Generally, the one with a 'w' at the beginning is your wireless interface, and the one starting with an 'e' is your ethernet interface. Go in the create_ap directory and execute the following command to start the network (replacing the given interfaces by yours) :

    ```bash
    echo -e "LDaaS_Demo\nILoveOCCIware" | sudo ./create_ap wlp2s0 enp3s0f1
    ```
And you're done !

New data will be poured every 5 minutes the Datacore, where they can be checked in the playground at http://10.28.7.17:8088/dc-ui/index_old.html (in project energy_0, by doing a GET /dc/type/enercons:EnergyConsumption_0 ).

Here are sample Blynk logs in this process :
````
16:30:04.147 ERROR- Error sending email auth token to user : admin@blynk.cc. Error: 535-5.7.8 Username and Password not accepted. Learn more at
535 5.7.8  https://support.google.com/mail/?p=BadCredentials 12sm1661108wmn.38 - gsmtp
16:30:54.222 INFO - admin@blynk.cc Blynk-app joined.
16:32:45.436 INFO - admin@blynk.cc hardware joined.
16:33:17.854 INFO - admin@blynk.cc hardware joined.
````
