import processing.video.*;
import twitter4j.conf.*;
import twitter4j.*;
import java.nio.file.Path;
//import java.nio.file.Paths;
import twitter4j.StatusUpdate;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.Status;
import java.io.File;
import java.nio.file.FileSystems;
import java.nio.file.FileSystem;


String consumerKey = ;
String consumerSecret = ;
String accessToken = ;
String accessSecret = ;

Twitter twitter;
Query query;

Capture video;
PImage result;
PImage prev;
PImage disp;
boolean first=true;
float couFrame=0;
void setup() {

  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey(consumerKey);
  cb.setOAuthConsumerSecret(consumerSecret);
  cb.setOAuthAccessToken(accessToken);
  cb.setOAuthAccessTokenSecret(accessSecret);

  twitter = new TwitterFactory(cb.build()).getInstance();


  size(640, 480);
  colorMode(RGB);
  video = new Capture(this, width, height, 30);
  result = createImage(video.width, video.height, RGB);
  disp = createImage(video.width, video.height, RGB);
  video.start();
}

void draw() {
  int cou=0;
  if (video.available()) {
    video.read();
  }
  if (first) {
    prev=video.get();
    first=false;
  }

  for (int i=0; i<video.width; i++) {
    for (int ii=0; ii<video.height; ii++) {
      int tmp=video.get(i, ii);
      //if (red(tmp)<200 && green(tmp)<=50 && blue(tmp)<=200)
      if (red(tmp)<=200 && green(tmp)<=50 && blue(tmp)<=50) {
        result.set(i, ii, color((red(tmp)+green(tmp)+blue(tmp))/6));
      } else {
//        result.set(i, ii, color(255, 255, 255));
        result.set(i, ii, color((red(tmp)+green(tmp)+blue(tmp))/2));
      }
      disp.set(i, ii, color(abs(red(prev.get(i, ii))-red(result.get(i, ii))), abs(green(prev.get(i, ii))-green(result.get(i, ii))), abs(blue(prev.get(i, ii))-blue(result.get(i, ii)))));
      if ((red(disp.get(i, ii))+blue(disp.get(i, ii))+green(disp.get(i, ii)))/3 > 220) {
        cou++;
      }
    }
  }

  if (cou>5 || couFrame<0) {
    println(couFrame);
    couFrame++;
  } else if (couFrame>0) {
    couFrame-=0.1;
  }
  if (couFrame >10) {
    couFrame=-100;
    println("gokiburi!");
    save("C:\\temp\\goki.png");
    try {
      FileSystem fs = FileSystems.getDefault();
      Path path = fs.getPath("C:\\temp\\goki.png");
      File file = path.toFile();

      twitter.updateStatus(
        new StatusUpdate("@3 I found Gokiburi!!! #rhenium_test_tweet").media(file));
    } 
    catch(TwitterException e) {
      println("Search tweets : " + e);
    }
  }
  image(video, 0, 0);
  prev = result.get();
}
