class Faces {
  float x = random(100, width - 100);
  float y = random(100, height - 100);
  float xOff = 0.0;
  float yOff = 0.0;
  float faceW = random(400, 800);
  float faceH = random(700, 900);
  int img = (int)random(4);
  float choose = random(20);
  float alpha = 0;
  float rise = random(0.4, 1.5);
  float life = 50; 

  boolean dead() {
    if (alpha < 0) {
      return true;
    } else {
      return false;
    }
  }

  void move() {

    if (choose < 1) {
      faceW += 5;
    } else if (choose < 2) {
      faceH += 5;
    } else if (choose < 3) {
      faceW += 5;
      faceH += 5;
    } else if (choose < 4) {
      faceW -= 5;
      faceH -= 5;

      if (faceW <= 0 || faceH <= 0 ) {
        faceW = 0;
        faceH = 0;
        choose = 5;
      }
    }
  }

  void warp() {
    faceH += 10;
  }
  
  void fade() {
    rise = -1;
  }

  void show() {
    imageMode(CENTER);
    tint(255, alpha);
    image(faceImg[img], x, y, faceW, faceH);

    alpha += rise;

    if (alpha >= 50) {
      alpha = 50;
      life --;
    }

    if (life < 0) {
      life = 0;
      rise = -rise;
    }
  };
}
