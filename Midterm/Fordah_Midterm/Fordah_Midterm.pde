import oscP5.*;
import netP5.*;
OscP5 oscP5;

float redAlpha = 0;

float x;

//Rain[] rain = new Rain[0];
ArrayList<Rain> rain;


void setup() {
  fullScreen();
  noCursor();
  //size(1000, 1000);
  frameRate(24);
  background(0);
  smooth();

  OscProperties properties = new OscProperties();
  properties.setListeningPort(47120); // osc receive port (from sc)
  oscP5 = new OscP5(this, properties);
  
  //for(int i = 0; i < rain.length; i++){
  //  rain[i] = new Rain();
  //}
  
  rain = new ArrayList<Rain>();
  //rain.add(new Rain());
  
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/heart")) {
    x = msg.get(0).floatValue(); // receive floats from sc
  }
  if (msg.checkAddrPattern("/bell")) {
    rain.add(new Rain());
    //rain = (Rain[]) append(rain, new Rain());
    //rain[0] = new Rain();
  }
}

void draw() {
  background(0, 0, 0);

  fill(153, 0, 0, redAlpha);
  noStroke();
  rect(0, 0, width, height);
  
  if (x == 1.0){
    redAlpha += 20;
  } else if (x == 0.0){
    redAlpha -= 10;
  }
  
  if (redAlpha < 0){
    redAlpha = 0;
  }else if (redAlpha > 140){
    redAlpha = 140; 
  }
  
  for(int i = rain.size()-1; i >= 0; i--){
    Rain drop = rain.get(i);
    drop.show();
    drop.fall();
    
    if(drop.finished()){
      rain.remove(i);
    }
  }
  

  
}
