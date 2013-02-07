/**
 * Class to draw objects
 *
 * 'h' -> hide realworld
 * 'b' -> toggle from polygon to box mode
 * 'backspace' -> delete realworld objects
 * 'd' or arduino button -> sets power and angle
 */
import fisica.*;

class RealWorld
{

  FPoly poly;
  boolean boxMode = false;
  // Length equal to real world objects
  // Change to hashtags that suit you
  String[] object_name = {
    "#osgemeos", 
    "#bleclerat", 
    "#banksy"
  };
  String[] current_tweets = new String[11];
  int names_index = 0;
  boolean hide = false;

  //Vars for BoxMode rectangle
  float [] p1x = new float[0]; // hold the mouse pressed marks
  float [] p1y = new float[0];
  float [] p1z = new float[0];
  float [] p2x = new float[0]; // hold the mouse pressed marks
  float [] p2y = new float[0];
  float [] p2z = new float[0];
  int count=0;

  int rect_x1; // catch the start dragging point x
  int rect_y1; // catch the start dragging point y
  int rect_x2; // record  moving mouseX
  int rect_y2; // record moving mouseY
  int rect_z1; // record mouseX releasing point
  int rect_z2; // record mouseY releasing point.

  void draw() {
    for (Object o: world.getBodies()) {
      FBody b = (FBody) o;
      if (b.isStatic())
        b.setDrawable(!hide);
      /* else
       b.setDrawable(hide);*/
    }

    if (boxMode == true && names_index < object_name.length) {
      Rect();
    }
  }

  void Rect() {
    float sizex = rect_x2 - rect_x1;
    float sizey = rect_y2 - rect_y1; 
    if (mousePressed && mouseButton == LEFT  ) {
      rect(rect_x1, rect_y1, sizex, sizey);
    }
  }


  void mousePressed() {
    if ( names_index < object_name.length ) { //Avoids the creation of real world objects without name
      poly = new FPoly();
      poly.setStrokeWeight(3);
      poly.setFill(0, 255, 0);
      poly.setDensity(10);
      poly.setRestitution(0.5);
      if ( boxMode == false) {
        poly.vertex(mouseX, mouseY);
      } 
      else if ( boxMode == true ) {
        p1x= append(p1x, mouseX);
        p1y= append(p1y, mouseY);
        rect_x1 = mouseX;
        rect_y1 = mouseY;
        mouseDragged(); // Reset vars
      }
    }
  }

  void mouseDragged() {
    if ( boxMode == false && poly!=null) {
      poly.vertex(mouseX, mouseY);
    }
    else if ( boxMode == true && poly!=null) {
      rect_x2 = mouseX;
      rect_y2 = mouseY;
    }
  }

  void mouseReleased() {
    if ( boxMode == false && poly!=null) {
        poly.setStatic(true);
        poly.setName(object_name[names_index]);
        println(poly.getName());
        world.add(poly);
        poly = null;
        names_index += 1;
    }
    else if ( boxMode == true && poly!=null) {
      p2x= append(p2x, mouseX);
      p2y= append(p2y, mouseY);
      rect_x2 = mouseX;
      rect_y2 = mouseY;
      count++;

      for (int i=0; i<count; i++) {
        poly.vertex(p1x[i], p1y[i]);
        poly.vertex(p2x[i], p1y[i]);
        poly.vertex(p2x[i], p2y[i]);
        poly.vertex(p1x[i], p2y[i]);
      }

      if ( poly!=null ) {
        poly.setStatic(true);
        poly.setName(object_name[names_index]);
        println(poly.getName());
        world.add(poly);
        poly = null;
        names_index += 1;
      }

      p1x = new float[0]; // hold the mouse pressed marks
      p1y = new float[0];
      p1z = new float[0];
      p2x = new float[0]; // hold the mouse pressed marks
      p2y = new float[0];
      p2z = new float[0];
      count =0;
    }


    //Get the tweets dragging when there are all objects on table
    if ( names_index == object_name.length )
      getTweets();
  }

  //Find correspondent index from body hit related to twitter array
  void hitBody (String actual_body) {
    for ( int i = 0; i < _realworld_.object_name.length; i++ ) {
      if ( actual_body == _realworld_.object_name[i] ) {
        println( current_tweets[i] );
        the_tweet = "" ;
        the_tweet = current_tweets[i] ;
      }
    }
  }

  void getTweets() {
    _twitter_ = new TwitterClass( 30, "TwitterThread" );
    println ( object_name.length );     
    println("##############################################################################################");
    println( current_tweets[0] );
    println( current_tweets[1] );
    println("##############################################################################################");
  }

  void keyPressed() {
    if (key == BACKSPACE) {
      names_index = 0;
      for (Object o: world.getBodies()) {
        FBody b = (FBody) o;
        if (b.isStatic() && b.getName() != null) //Only removes objects in real world with name excluding world edges this way
          world.remove(b);
      }
    }

    if (key == 'b')
      boxMode = !boxMode;

    if (key == 'h')
      hide = !hide;
  }
}

