/**
 * Twitter Class 
 * 
 * Get tweets from _realworld_.object_name
 * Based on @RobotGrrl example http://robotgrrl.com/blog/2011/02/21/simple-processing-twitter/
 */
 
import twitter4j.conf.*;
import twitter4j.internal.async.*;
import twitter4j.internal.org.json.*;
import twitter4j.internal.logging.*;
import twitter4j.json.*;
import twitter4j.internal.util.*;
import twitter4j.management.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import twitter4j.util.*;
import twitter4j.internal.http.*;
import twitter4j.*;
import twitter4j.internal.json.*;

class TwitterClass extends Thread
{

  boolean running;           // Is the thread running?  Yes or no?
  int wait;                  // How many milliseconds should we wait in between executions?
  String id;                 // Thread name
  int count; //test

  // This is where you enter your Oauth info
  String OAuthConsumerKey = "XXXXXXXXXXXXXXXXXXXXX";  
  String OAuthConsumerSecret = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

  // This is where you enter your Access Token info
  String AccessToken = "XXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
  String AccessTokenSecret = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

  Twitter twitter = new TwitterFactory().getInstance();
  String[] theSearchTweets = new String[11];


  TwitterClass (int w, String s) {
    println("#####################Thread Started##########################"); 
    wait = w;
    running = false;
    id = s;
    start();
  }

  // Overriding "start()"
  void start () {
    running = true;
    println("Starting thread (will execute every " + wait + " milliseconds.)"); 
    // Do whatever start does in Thread, don't forget this!
    super.start();
  }

  void run () {

    // Ok, let's wait for however long we should wait
    for ( int i = 0; i < _realworld_.object_name.length; i++ ) {
      _twitter_.getSearchTweets( _realworld_.object_name[i], i );
    }
    
    try {
      sleep((long)(wait));
    } 
    catch (Exception e) {
    }
    
    _realworld_.current_tweets = theSearchTweets;
    System.out.println(id + " #####################Thread Quiting##########################!");
    quit();
  }

  void quit() {
    System.out.println("Quitting."); 
    running = false;  // Setting running to false ends the loop in run()
    // IUn case the thread is waiting. . .
    interrupt();
  }


  void connectTwitter() {

    twitter.setOAuthConsumer(OAuthConsumerKey, OAuthConsumerSecret);
    AccessToken accessToken = loadAccessToken();
    twitter.setOAuthAccessToken(accessToken);
  }

  private  AccessToken loadAccessToken() {
    return new AccessToken(AccessToken, AccessTokenSecret);
  }

  // Search for tweets
  void getSearchTweets( String queryStr, int increment ) {

    try {
      Query query = new Query(queryStr);    
      query.setRpp(1); // Get 10 of the x search results  
      QueryResult result = twitter.search(query);    
      ArrayList tweets = (ArrayList) result.getTweets();    

      for ( int i=0; i<tweets.size(); i++ ) {	
        Tweet t = (Tweet)tweets.get(i);	
        String user = t.getFromUser();
        String msg = t.getText();
        Date d = t.getCreatedAt();	
        //theSearchTweets[i] = msg.substring( queryStr.length()+1 );
        theSearchTweets[increment] = user + ": " + msg;

        //println(theSearchTweets[i]);

        println(user);
        println(msg);
      }
    } 
    catch (TwitterException e) {    
      println("Search tweets: " + e);
    }
  }
}

