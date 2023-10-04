#include <freertos/FreeRTOS.h>
#include <freertos/task.h>

#include <Arduino.h>
#include <WiFi.h>

#include <Firebase_ESP_Client.h>
#include <ESP32Servo.h>
#include <LiquidCrystal_I2C.h>
#include <Adafruit_Sensor.h>
#include "time.h"
#include "DHT.h"
#include <Adafruit_Sensor.h>
#include <Adafruit_BME280.h>

#include "UltrasonicSensor.h"
#include "Robot.h"

#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

int servoSprayPin = 32;
int trigPin = 18;
int echoPin = 2;
int flamePinL = 34;
int flamePinR = 4;
int servoUltraPin = 33;
int maximum_distance = 400;

#define SEALEVELPRESSURE_HPA (1013.25)
Adafruit_BME280 bme;                    // I2C
LiquidCrystal_I2C lcd_i2c(0x27, 16, 2); // I2C address 0x27, 16 column and 2 rows
UltrasonicSensor ultrasonic(trigPin, echoPin, servoUltraPin, maximum_distance);
Robot myRobot(25, 13, 19, 5, 15, 23);
Servo servoSpray;


void flameTest()
{
  int flameReadingL = analogRead(flamePinL);
  int flameReadingR = analogRead(flamePinR);

  bool fireExists = flameReadingL < 4000 || flameReadingR < 4000;
  int diffrenceThreshold = 500;
  bool isDiffrenceBiggerThanThreshold = abs(flameReadingL - flameReadingR) > diffrenceThreshold;
  bool isDiffrenceBetweenThreshold = abs(flameReadingL - flameReadingR) < diffrenceThreshold;
  bool isCloseToFlame = flameReadingL < 400 || flameReadingR < 400;
  bool isFarFromFlame = flameReadingL > 3000 && flameReadingR > 3000;

  // check if there's fire
  while (flameReadingL < 4000 || flameReadingR < 4000)
  {
    myRobot.stop();
    delay(1000);

    if (flameReadingL > 2000 || flameReadingR > 2000)
    {
      lcd_i2c.print("MOVING AWAY");
      break;
    }

    // go to the correct position
    while (abs(flameReadingL - flameReadingR) > 500)
    {

      if (flameReadingL > flameReadingR)
      {
        myRobot.toRight();
      }
      else
      {
        myRobot.toLeft();
      }

      delay(15);
      myRobot.stop();
      delay(200);

      // re-read values
      flameReadingL = analogRead(flamePinL);
      flameReadingR = analogRead(flamePinR);

      if (isFarFromFlame)
      {
        lcd_i2c.print("MOVING AWAY");
        break;
      }
    }

    while (abs(flameReadingL - flameReadingR) < 500)
    {
      lcd_i2c.clear();
      lcd_i2c.setCursor(0, 0);
      lcd_i2c.print("I'M BETWEEN THE THRESHOLD");
      lcd_i2c.setCursor(0, 1);
      lcd_i2c.print(abs(flameReadingL - flameReadingR));
      myRobot.forward();
      delay(200);
      myRobot.stop();
      while (flameReadingL < 400 || flameReadingR < 400)
      {
        lcd_i2c.clear();
        lcd_i2c.setCursor(0, 0);
        lcd_i2c.print("I'M CLOSE TO THE FLAM NOW");
        delay(1000);
        myRobot.stop();
        flameReadingL = analogRead(flamePinL);
        flameReadingR = analogRead(flamePinR);
        lcd_i2c.clear();
        lcd_i2c.print("EXTINGUISHING");
        delay(1000);

        if (flameReadingL > 2000 && flameReadingR > 2000)
        {
          lcd_i2c.clear();
          lcd_i2c.print("DONE EXTINGUISHING");
          delay(1000);
          break;
        }
      }
    }
  }
}


// Insert your network credentials
#define WIFI_SSID "WIFI"
#define WIFI_PASSWORD "WIFI_PASSWORD"

// Insert Firebase project API Key
#define API_KEY "AIzaSyBCNvfd9olzwfTceLlBHNtqSk9kt_dL9yo"

// Insert Authorized Email and Corresponding Password
#define USER_EMAIL "hello@world.com"
#define USER_PASSWORD "123456789"

// Insert RTDB URLefine the RTDB URL
#define DATABASE_URL "https://iot3-flutter-default-rtdb.firebaseio.com/"

// Define Firebase objects
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

String uid;

// bool isFirebaseReady = false;

FirebaseJson json;
FirebaseJson Ajson;
FirebaseJson Ujson;
const char *ntpServer = "pool.ntp.org";

unsigned long sendDataPrevMillis = 0;
unsigned long timerDelay = 100;

// Initialize WiFi
void initWiFi() {
  
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.println("Connecting to WiFi ..");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print('.');
    delay(1000);
  }
  Serial.print("\nConnected Successfully\nIp is: ");
  Serial.println(WiFi.localIP());
  Serial.println();
}

void movement(String direction)
{
  if (direction == "8")
  {
    myRobot.forward();
  }
  else if (direction == "6")
  {
    myRobot.toRight();
    delay(250);
    myRobot.stop();
    json.set(String("/moving"), String("5"));
    Serial.printf("Set json... %s\n", Firebase.RTDB.setJSON(&fbdo, String("/direction"), &json) ? "ok" : fbdo.errorReason().c_str());
  }
  else if (direction == "4")
  {
    myRobot.toLeft();
    delay(250);
    myRobot.stop();
    json.set(String("/moving"), String("5"));
    Serial.printf("Set json... %s\n", Firebase.RTDB.setJSON(&fbdo, String("/direction"), &json) ? "ok" : fbdo.errorReason().c_str());
  }
  else if (direction == "2")
  {
    myRobot.backward();
  }
  else if (direction == "5")
  {
    myRobot.stop();
  }
  else if (direction == "7")
  {
    avoid();
  }
}


void setup()
{
  Serial.begin(115200);
  pinMode(flamePinR, INPUT);
  pinMode(flamePinL, INPUT);

  bme.begin(0x76);

  servoSpray.attach(servoSprayPin);
  servoSpray.write(0);



  lcd_i2c.init();
  lcd_i2c.begin(16, 2);
  lcd_i2c.backlight();
  lcd_i2c.clear();

  // start Wifi
  initWiFi();
  configTime(0, 0, ntpServer);
  config.api_key = API_KEY;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;
  config.database_url = DATABASE_URL;
  Firebase.reconnectWiFi(true);
  fbdo.setResponseSize(4096);
  config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h
  config.max_token_generation_retry = 5;
  Firebase.begin(&config, &auth);
  Serial.println("Getting User UID");
  while ((auth.token.uid) == "") {
    Serial.print('.');
    delay(1000);
  }

  json.set("/moving", "7");
  Serial.printf("Set default moving json... %s\n", Firebase.RTDB.setJSON(&fbdo, "/direction", &json) ? "ok" : fbdo.errorReason().c_str());
}

void avoid(){
  int distance = ultrasonic.readPing();
  const int obstacleThreshold = 25;
  if (distance <= obstacleThreshold) {
    myRobot.stop();
    delay(300);
    myRobot.backward();
    delay(100);
    myRobot.stop();
    delay(800);

    int distanceRight = ultrasonic.lookRight();
    delay(300);
    int distanceLeft = ultrasonic.lookLeft();
    delay(300);

    if (distanceLeft >= distanceRight) {
      myRobot.toLeft();
      delay(250);
      Serial.println("LEFT");
    }
    else if (distanceLeft <= distanceRight) {
      myRobot.toRight();
      delay(250);
      Serial.println("RIGHT");
    }
    else {
      myRobot.rotate();
      delay(500);
      Serial.println("ROTAT");
    }
    myRobot.stop();
    delay(500);
  }
  else {
    myRobot.forward();
    Serial.println("FORWARD");
  }
}

void loop() {
  Serial.println("IN LOOP");
  // flameTest();
  if (millis() - sendDataPrevMillis > timerDelay || sendDataPrevMillis == 0)
  {
    Serial.println("FIREBASE READY");
    Serial.printf("Get move... %s\n", Firebase.RTDB.getString(&fbdo, String("/direction/moving")) ? "got new direction" : fbdo.errorReason().c_str());
    String directionOrder = fbdo.to<String>();
    Serial.println(directionOrder);
    movement(directionOrder);
    int flameReading = analogRead(flamePinL);
    int flame = map(flameReading, 0, 4095, 300, 10000);
    Serial.printf("Set flame json... %s\n", Firebase.RTDB.setFloat(&fbdo, String("/reading/flame"), flame) ? "ok" : fbdo.errorReason().c_str());
    Serial.printf("Set ultra json... %s\n", Firebase.RTDB.setFloat(&fbdo, String("/reading/Uultra"), ultrasonic.readPing()) ? "ok" : fbdo.errorReason().c_str());
    }
}