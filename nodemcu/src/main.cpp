/* Comment this out to disable prints and save space */
#define BLYNK_PRINT Serial

#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <BlynkSimpleEsp8266.h>

// You should get Auth Token in the Blynk App.
// Go to the Project Settings (nut icon).
char auth[] = "9a878c0c30614945aa4de47bbb525908";

// Your WiFi credentials.
// Set password to "" for open networks.
char ssid[] = "LDaaS_Demo";
char pass[] = "ILoveOCCIware";

void setup()
{
  // Debug console
  Serial.begin(9600);

  Blynk.begin(auth, ssid, pass, IPAddress(31,172,165,251));
}

void loop()
{
  Blynk.run();
}
