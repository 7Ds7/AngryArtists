#ifndef PushUpButton_H
#define PushUpButton_H

#include <Arduino.h>

class PushUpButton 
{
public:
  PushUpButton( int pin );
  ~PushUpButton();
  void CheckState();
};

#endif

