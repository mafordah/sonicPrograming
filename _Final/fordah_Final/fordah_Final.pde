import oscP5.*;
import netP5.*;
OscP5 oscP5;

PImage theater;
PImage theaterPost;
PImage theaterFaces;
PImage theaterFacesBW;
PImage eyes;
PImage mouth;
PImage[] faceImg = new PImage[4];

float alpha = 0;

float x;
float y;

float stretchX;
float stretchY;
float moveY;
float scale = 1.0;
float scaleSpeed = 0.05;

ArrayList <Faces> faces;


void setup() {
  fullScreen();
  noCursor();
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
  eyes = loadImage("faceEyes.png");
  mouth = loadImage("faceMouth.png");

  for (int i = 0; i < 4; i++) {
    faceImg[i] = loadImage("face"+(i + 1)+".png");
  }

  faces = new ArrayList<Faces>();

  stretchX = width;
  stretchY = height;
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/start")) {
    x = msg.get(0).floatValue();
  }

  if (msg.checkAddrPattern("/face")) {
    faces.add(new Faces());
    y = msg.get(0).floatValue();
  }
}


void draw() {
  background(0);
  imageMode(CORNER);
  image(theater, 0, 0, width, height);

  if (x == 1.0) {
    imageMode(CORNER);
    image(theaterPost, 0, 0, width, height);
  } else if (x == 2.0) {
    imageMode(CORNER);
    image(theaterFaces, 0, 0, width, height);
  } else if (x == 3.0) {
    imageMode(CORNER);
    image(theaterFacesBW, 0, moveY, stretchX, stretchY);

    stretchY += 10;
    //println(stretchY);

    if (stretchY > (height * 1.25)) {
      moveY -= 2.4;
    }
  } else if (x == 4.0) {
    fill(0);
    noStroke();
    rect(0, 0, width, height);
  } else if (x >= 5.0) {
    fill(0);
    noStroke();
    rect(0, 0, width, height);

    float blinkTime = random(20);



    if (blinkTime > 1) {
      tint(255, 255);
      imageMode(CENTER);
      image(eyes, width/2, height/2, width, height);
    } else {
      tint(255, 255);
      imageMode(CENTER);
      image(eyes, width/2, height/2 - (120), width, height/9);
    }

    tint(255, 255);
    imageMode(CENTER);
    image(mouth, width/2, height/2, width, height);
  } 
  
  if (x == 6.0) {
    tint(255, alpha);
    imageMode(CORNER);
    image(theater, 0, 0, width, height);

    alpha += 10;

    if (alpha >= 255) {
      alpha = 255;
    }
  }

  for (int i = faces.size()-1; i >= 0; i--) {
    Faces face = faces.get(i);
    //if (x == 4.0) {
    face.show();
    //}

    if ( y == 2.0 ) {
      face.warp();
    } else {
      face.move();
    }

    if (face.dead()) {
      faces.remove(i);
      if (x != 6.0) {
        faces.add(new Faces());
      }
    }

    if (x == 6.0) {
      face.fade();
    }
  }
}
