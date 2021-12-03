import oscP5.*;
import netP5.*;
OscP5 oscP5;

PImage theater;
PImage theaterPost;
PImage theaterFaces;
PImage theaterFacesBW;

float alpha = 0;

float x = 0.0;

float stretchX;
float stretchY;
float moveY;



void setup() {
  fullScreen();
  //noCursor();
  //size(1080, 720);
  frameRate(60);
  background(0);
  smooth();

  OscProperties properties = new OscProperties();
  properties.setListeningPort(47120); // osc receive port (from sc)
  oscP5 = new OscP5(this, properties);
  
  theater = loadImage("theaterFull.png");
  theaterPost = loadImage("theaterPost.png");
  theaterFaces = loadImage("theaterFacesRed.png");
  theaterFacesBW = loadImage("theaterFacesBW.png");
  
  stretchX = width;
  stretchY = height;
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/start")) {
    x = msg.get(0).floatValue(); // receive floats from sc
  }
}


void draw() {
  background(255, 255, 255);
  image(theater, 0, 0, width, height);
  //fill(10, 15, 10, alpha);
  //noStroke();
  //rect(0, 0, width, height); 
  
  if (x == 1.0){
    
    image(theaterPost, 0, 0, width, height);
    
  } else if (x == 2.0){
    
    image(theaterFaces, 0, 0, width, height);
    
  } else if (x == 3.0){
    
    image(theaterFacesBW, 0, moveY, stretchX, stretchY);
    
    stretchY += 10;
    //println(stretchY);
    
    if(stretchY > (height * 1.25)) {
      moveY -= 2.4;
    }
    
  }
  
  

}
