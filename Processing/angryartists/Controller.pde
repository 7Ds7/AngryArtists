/**
 * Controler class
 * to controll power and angle
 */
 
class Controller 
{

  float power = 0;
  float angle = 4.5;
  boolean grow = true;
  char state = 'P';


  void draw() {
    //fill(0, 0, 0);
    //remove for worldedges
    //noStroke();

    switch (state) {
    case 'P':
      drawPower();
      power +=1;
      drawAngleHold();
      break;
    case 'A':
      drawPowerHold();
      drawAngle();
      break;
    case 'L':
      setLaunch ( power, angle );
      break;
    default:
      break;
    }
    drawAngleStroke();
  }

  void drawPower() {
    noStroke();
    fill( power, 50, 50);
    if ( grow == true ) {
      power += power * 0.1;
    } 
    else if ( grow == false ) {
      power -= power * 0.1;
    }
    ellipse(0, 768, power, power);
    if ( power >= 200)
      grow = false;
    if ( power <= 10)
      grow = true;
  }

  void drawPowerHold() {
    noStroke();
    fill( power , 50, 50);
    ellipse(0, 768, power, power);
  }

  void drawAngle() {
    noFill();
    stroke( 50, 50, 50 );
    strokeWeight( 30 ); //10 is max for opengl
    if ( grow == true ) {
      angle -=  0.09;
    } 
    else if ( grow == false ) {
      angle +=  0.09;
    }
    arc ( 0, 768, 250, 250, angle, TWO_PI );
    if ( angle > 6.5 )
      grow = true;
    if ( angle < 4.5 )
      grow = false;
  }

  void drawAngleStroke () {
    noFill();
    strokeWeight(5);
    stroke( 0, 0, 0 );
    ellipse ( 0, 768, 233, 233 ); // +10 with opengl
    ellipse ( 0, 768, 267, 267 ); // -10 with opengl
  }

  void drawAngleHold() {
     noFill();
    stroke( 50, 50, 50 ); //10 is max for opengl
    strokeWeight( 30 );
    arc ( 0, 768, 250, 250, angle/2, TWO_PI );
  }

  void setLaunch( float pw, float an ) {
    float max_pw = 30;
    float trans_pw = 200;
    float res_pw  = (pw * max_pw) / trans_pw;

    float res_an = (an - 6.5) * 45;
    //  println ("Res -> " + res_an);

    launchBall( res_pw, res_an );
  }
}

