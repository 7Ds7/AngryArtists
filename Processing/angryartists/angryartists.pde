/**
 * 'h' -> hide realworld
 * 'b' -> toggle from polygon to box mode
 * 'backspace' -> delete realworld objects
 * 'd' or arduino button -> sets power and angle
 *
 * Export as application for your OS to run in fullscreen
 * default dimensions 1024x768
 */

import fisica.*;
import processing.opengl.*;

FCircle ball;
FWorld world;
FWorld world2;
FPoly poly;

Controller _controller_;
RealWorld _realworld_;
ArduinoSerial _serial_;
TwitterClass _twitter_;

boolean debug = false; // Set to true if arduino serial is not available for keyboard debug only
PFont font;

int stage_width = 1024;
int stage_height = 768;
int num_throws = 0;

boolean hide = false;
boolean kPressed = false;

String the_tweet ="";
int x_text = 1024;
float width_text = 0;

PApplet ROOT = this;


void setup() {
  size( stage_width, stage_height, OPENGL);
  frameRate(60);
  hint(ENABLE_OPENGL_4X_SMOOTH);
  hint(DISABLE_OPENGL_ERROR_REPORT);
  Fisica.init(this);

  world = new FWorld();
  world.setEdges( -10, 40, 1024 +10, 768, color(255, 255, 100) ); 
  world.remove( world.bottom ) ;
  world.setGravity(0, 700);

  world2 = new FWorld();
  /*world2.setEdges( -10, 70, 1024 +10, 768, color(255, 255, 100) );
   world2.remove( world2.bottom ) ;*/
  world2.setGravity(0, 10);

  _controller_ = new Controller();
  _realworld_ = new RealWorld();

  font = loadFont("DS-Digital-48.vlw"); 
  textFont(font);

  if ( debug == false ) {
    _serial_ = new ArduinoSerial();
    _serial_.setup();
  }
}

void draw() {
  background(255);
  _controller_.draw();
  world.step();
  world2.step();
  _realworld_.draw();

  world.draw(this);
  world2.draw(this);

  //Draw Real world object while it hasn't been added to the world yet
  if ( _realworld_.poly != null) {
    _realworld_.poly.draw(this);
  }

  //Prevents the app from crashing while assigning the_tweet
  if ( the_tweet != null ) {
    writeTweet(the_tweet);
  }  

  if ( debug == false ) {
    _serial_.checkButton();
  }
}


void contactStarted(FContact contact) {
  if ( contact.getBody1().getName() !=null && contact.getBody2().getName() == "ball" ) {
    String actual_hit = contact.getBody1().getName();
    _realworld_.hitBody( actual_hit );
    explodeBall( contact.getBody2());
    x_text = 1024;
    //Set ball Null to not get anymore data
    // contact.getBody2().setName("null");
  }
  //println( "Ball hitted a body with name -> " +  contact.getBody1().getName() );
}

void explodeBall (FBody actual_ball) {
  for (int i = 0; i < 15; i++ ) {
    FPoly myPoly = new FPoly();
    myPoly.vertex(5, 5);
    myPoly.vertex(-5, 5);
    myPoly.vertex(0, -5);
    myPoly.setPosition( actual_ball.getX(), actual_ball.getY());
    //myPoly.addForce( random(-90,90) , random(-90,90));
    myPoly.setRotation(random(TWO_PI));
    myPoly.setVelocity( random(-180, 180), random(-180, 180));
    float r = random (255);
    float g = random (255);
    float b = random (255);
    myPoly.setFill( r, g, b, (float) 70 );
    myPoly.setStrokeColor( color( r, g, b ) );
    myPoly.setSensor( true );
    myPoly.setRotatable(true);
    myPoly.setAngularVelocity(random(50));
    world2.add(myPoly);
  }
  world.remove( actual_ball );
}

void writeTweet(String thetweet) {
  //LCD rect
  noStroke();
  fill(0, 0, 0);
  rect (0, 0, stage_width, 50 );
  fill(20, 20, 20);
  text( "000000000000000000000000000000000000000000", 0, 10, stage_width, 170);
  text( "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", 0, 10, stage_width, 170);

  // Text on LCD
  width_text =  textWidth( thetweet );
  fill(192, 0, 0);
  if ( x_text >= -( width_text ) ) {
    text( thetweet, x_text, 10, width_text, 170);
    x_text -= 5;
  }
  else {
    x_text = 1024;
  }
  //redraw();
}

void keyPressed() {
  // println("keypressed");
  // println(keyCode);
  if ( key == 'd' && kPressed == false ) {
    println(_controller_.state);
    switch ( _controller_.state ) {
    case 'P':
      cleanObjects();
      _controller_.state = 'A';
      //_controller_.grow = true;
      //  println("power ->" + _controller_.power);
      break;
    case 'A':
      _controller_.state = 'L';
      //_controller_.grow = true;
      // println("angle ->" + _controller_.angle);
      break;
    default:
      break;
    }

    kPressed = true;
  }

  _realworld_.keyPressed();
}

void keyReleased() {
  if ( key == 'd' && kPressed == true) 
    kPressed = false;
}

/**
 * Clean objects that are below stage height
 * to ease on memory
 */
void cleanObjects () {
  ArrayList all_bodies = world.getBodies();
  for (int i = all_bodies.size()-1; i >= 0; i--) { 
    FBody cur_body = (FBody) all_bodies.get(i);
    float y = cur_body.getY();
    if ( y >= stage_height ) {
      world.remove( cur_body );
    }
  }

  all_bodies = world2.getBodies();
  for (int i = all_bodies.size()-1; i >= 0; i--) { 
    FBody cur_body = (FBody) all_bodies.get(i);
    float y = cur_body.getY();
    if ( y >= stage_height ) {
      world2.remove( cur_body );
    }
  }
}

void launchBall(float pw, float an) {
  println( world.getBodies());
  println( world2.getBodies());
  ball = new FCircle(40);
  ball.setPosition( 0, stage_height );
  ball.setName("ball");

  float angle= an;
  //angle= radius (angle/57.29577951);
  float speed= pw;
  float radius = 100;
  float spx = cos(radians(angle)) * radius;
  float spy = sin(radians(angle)) * radius;
  // println ("spx ->" + speed*spx);
  // println ("spy ->" + speed*spy);

  ball.setVelocity( speed*spx, speed*spy);
  ball.setFillColor(#000000);
  ball.setRotation(10);
  ball.setNoStroke();
  ball.setStatic(false);
  world.add(ball);
  _controller_.state = 'P';
  num_throws += 1;
  if ( num_throws >= 3 ) {
    _realworld_.getTweets(); 
    num_throws = 0;
  }
}

void mousePressed() {
  _realworld_.mousePressed();
}

void mouseDragged() {
  _realworld_.mouseDragged();
}

void mouseReleased() {
  _realworld_.mouseReleased();
}

