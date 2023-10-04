#include "Robot.h"

// Constructor
//            left      left   right     right
Robot::Robot(int m1F, int m1B, int m2F, int m2B, int ena, int enb) : m1_F_pin(m1F), m1_B_pin(m1B), m2_F_pin(m2F), m2_B_pin(m2B), ena_a_pin(ena), ena_b_pin(enb)
{
  pinMode(m1_F_pin, OUTPUT);
  pinMode(m1_B_pin, OUTPUT);
  pinMode(m2_F_pin, OUTPUT);
  pinMode(m2_B_pin, OUTPUT);
  pinMode(ena_a_pin, OUTPUT);
  pinMode(ena_b_pin, OUTPUT);
}

// Forward function
void Robot::backward()
{
  digitalWrite(m1_F_pin, HIGH);
  digitalWrite(m1_B_pin, LOW);
  digitalWrite(m2_F_pin, HIGH);
  digitalWrite(m2_B_pin, LOW);
  analogWrite(ena_a_pin, 225);
  analogWrite(ena_b_pin, 225);
  Serial.println("BACKWORD");
}

// Backward function
void Robot::forward()
{
  digitalWrite(m1_F_pin, LOW);
  digitalWrite(m1_B_pin, HIGH);
  digitalWrite(m2_F_pin, LOW);
  digitalWrite(m2_B_pin, HIGH);
  analogWrite(ena_a_pin, 225);
  analogWrite(ena_b_pin, 225);
  Serial.println("FORWARD");
  }

// Turn Left function
void Robot::toRight()
{
  digitalWrite(m1_F_pin, LOW);
  digitalWrite(m1_B_pin, HIGH);
  digitalWrite(m2_F_pin, HIGH);
  digitalWrite(m2_B_pin, LOW);
  analogWrite(ena_a_pin, 225);
  analogWrite(ena_b_pin, 225);
  Serial.println("RIGHT");

}

// Turn Right function
void Robot::toLeft()
{
  digitalWrite(m1_F_pin, HIGH);
  digitalWrite(m1_B_pin, LOW);
  digitalWrite(m2_F_pin, LOW);
  digitalWrite(m2_B_pin, HIGH);
  analogWrite(ena_a_pin, 225);
  analogWrite(ena_b_pin, 225);
  Serial.println("LEFT");
}

// Rotate function
void Robot::rotate()
{
  digitalWrite(m1_F_pin, LOW);
  digitalWrite(m1_B_pin, HIGH);
  digitalWrite(m2_F_pin, HIGH);
  digitalWrite(m2_B_pin, LOW);
  analogWrite(ena_a_pin, 225);
  analogWrite(ena_b_pin, 225);
  Serial.println("ROTART");
}

// Stop function
void Robot::stop()
{
  digitalWrite(m1_F_pin, LOW);
  digitalWrite(m1_B_pin, LOW);
  digitalWrite(m2_F_pin, LOW);
  digitalWrite(m2_B_pin, LOW);
  analogWrite(ena_a_pin, 225);
  analogWrite(ena_b_pin, 225);
  Serial.println("STOP");
}
