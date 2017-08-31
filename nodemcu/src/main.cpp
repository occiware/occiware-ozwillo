/* Comment this out to disable prints and save space */
#define BLYNK_PRINT Serial

#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <BlynkSimpleEsp8266.h>

// You should get Auth Token in the Blynk App.
// Go to the Project Settings (nut icon).
char auth[] = "ed5dfb4e5abb493b9f2cd116de8de597";

// You should get the CUSTOMER_KEY associated to this device from the Datacore
// Here it is the one associated with Jacques Colard (persid=39080212)
String CUSTOMER_KEY = "8342962";

// Your WiFi credentials.
// Set password to "" for open networks.
char ssid[] = "LDaaS_Demo";
char pass[] = "ILoveOCCIware";

BlynkTimer timer;
const int long TIME_DURATION = 60000L;
String payload = "";

float generateMockEnergyData() {
    static float data = 0.5;
    data = (float)random(100) / 1000;

    return data;
}

void sendUptime()
{
  // This function sends Arduino up time every 1 second to Virtual Pin (V5)
  // You can send anything with any interval using this construction
  // Don't send more that 10 values per second

  payload = "CUSTOMER_KEY=" + CUSTOMER_KEY + ";"+ "CONSUMPTION=" + generateMockEnergyData() + ";";

  Blynk.virtualWrite(V5, payload);
}

void setup()
{
  // Debug console
  Serial.begin(9600);

  Blynk.begin(auth, ssid, pass, IPAddress(31,172,165,251));

  timer.setInterval(TIME_DURATION, sendUptime); //  Here you set interval (1sec) and which function to call

  randomSeed(analogRead(0));
}

void loop()
{
  Blynk.run();
  timer.run(); // BlynkTimer is working...
}
