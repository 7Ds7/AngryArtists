#include <PushUpButton.h>

int button_pin = 2;

int button_state = 0;


//<<constructor>>
PushUpButton::PushUpButton( int pin ) {
		button_pin = pin;
  pinMode ( button_pin, INPUT );
}

PushUpButton::~PushUpButton () {
}

void PushUpButton::CheckState () {
  button_state = digitalRead(button_pin);
}


