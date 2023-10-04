#ifndef ROBOT_H
#define ROBOT_H

#include <Arduino.h>

class Robot
{
private:
  int m1_F_pin, m1_B_pin, m2_F_pin, m2_B_pin, ena_a_pin, ena_b_pin;

public:
  Robot(int m1F, int m1B, int m2F, int m2B, int ena, int enb);
  void forward();
  void backward();
  void toLeft();
  void toRight();
  void rotate();
  void stop();
};

#endif
