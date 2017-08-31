# NodeMCU subproject

## Introduction

This folder contains all the sources required to flash the NodeMCU device with the OCCIware LDaaS demo code. This code has two purposes :

+ Generate mock energy consumption data,

+ Connect to a local WI-FI network and then to the demo Blynk server to regularly send it the mock energy consumption data.

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
