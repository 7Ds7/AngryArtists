/**
 * Serial Class
 * Gets button state from Arduino
 */
import processing.serial.*;
import java.awt.AWTException;
import java.awt.Robot;

class ArduinoSerial
{
  Serial myPort;
  int hard_button;
  int current_button = 0;
  Robot r;


  void setup() {

    println(Serial.list());
    String portName = Serial.list()[1];
    myPort = new Serial(ROOT, portName, 9600);
    myPort.bufferUntil('\n');


    try {
      r = new Robot();
    }
    catch(AWTException a) {
    }
  }

  void checkButton() {

    if (0 < myPort.available()) { 

      String myString = myPort.readStringUntil('\n');
      // if you got any bytes other than the linefeed:
      if (myString != null) {
        myString = trim(myString);
        current_button = Integer.parseInt(myString);
      }

     // println("hardbutton ->" + hard_button);
      if ( hard_button != current_button ) {
        r.keyRelease(68);
        hard_button = current_button;
      }
      if ( hard_button == 0 ) { // 0 button down 1 up
        //println("buttonpressed");
        r.keyPress(68);
      }
    }
  }
}

