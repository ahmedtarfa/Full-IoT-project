#include "UltrasonicSensor.h"

UltrasonicSensor::UltrasonicSensor(int trig, int echo, int servoPin, int maxDist)
    : trigPin(trig), echoPin(echo), servoUltraPin(servoPin), sonar(trig, echo, maxDist)
{
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  servoUltra.attach(servoUltraPin);
  servoUltra.write(115);
}

int UltrasonicSensor::readPing()
{
  delay(70);
  int cm = sonar.ping_cm();
  if (cm == 0)
  {
    cm = 250;
  }
  return cm;
}

int UltrasonicSensor::lookRight()
{
  servoUltra.write(30);
  delay(500);
  int distance = this->readPing();
  delay(100);
  servoUltra.write(115);
  return distance;
}

int UltrasonicSensor::lookLeft()
{
  servoUltra.write(180);
  delay(500);
  int distance = this->readPing();
  delay(100);
  servoUltra.write(115);
  return distance;
}