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
