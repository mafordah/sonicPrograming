class Rain {
  float rainX = random(0, width);
  float rainY = -200;
  float size = 0;
  float splashAlpha = 255;
  
  void fall(){
    rainY += 150;
  };
  
  void splash(float splashX){
    
    
    if (redAlpha == 0){
      stroke(255, splashAlpha);
    } else if (x == 0.0){
      stroke(0, splashAlpha);
    }
    
    size += 25;
    
    if (size >= 300){
      splashAlpha -= 10;
    }
      ellipse(splashX, height*4/5, size, size/4);
  };
  
  boolean finished() {
    if (splashAlpha < -200){
      return true; 
    } else {
      return false;
    }
  }
  
  void show(){
    if (x == 1.0){
      stroke(0);
    } else if (x == 0.0){
      stroke(255);
    }
    
    line(rainX, rainY, rainX, rainY + 200);
    if (rainY >= height*4/5){
      splash(rainX);
    }
  };
}
