#ifndef ULTRASONICSENSOR_H
#define ULTRASONICSENSOR_H

#include <NewPing.h>
#include <ESP32Servo.h>

class UltrasonicSensor
{
private:
  int trigPin;
  int echoPin;
  int servoUltraPin;
  NewPing sonar;
  Servo servoUltra;

public:
  UltrasonicSensor(int trig, int echo, int servoPin, int maxDist);
  int readPing();
  int lookRight();
  int lookLeft();
};

#endif