//#include <PushUpButton.h>

//#PushUpButton _pushButton_(2);
int led_pin = 13;
int button_pin = 2;
int button_state = 0;

void setup(){
  Serial.begin(9600);
  pinMode ( led_pin, OUTPUT );
  pinMode ( button_pin, INPUT );
  digitalWrite ( button_pin, HIGH );
}

void loop () {
  //_pushButton_.CheckState();
  if (CheckState() == LOW) {     
    // turn LED on:    
    digitalWrite(led_pin, HIGH);  
  } 
  else {
    // turn LED off:
    digitalWrite(led_pin, LOW); 
  }
  Serial.println( CheckState() );
  delay(100);
}

int CheckState() {
  int ret;
  button_state = digitalRead (button_pin);
  if ( button_state == HIGH ) {
    ret = 1;
  }
  else {
    ret = 0; 
  }
  return ret;
}

