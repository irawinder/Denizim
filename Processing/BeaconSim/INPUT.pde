//  Input -1 = none
//  Input  0 = drag
//  Input  1 = horizontal scroll bar
int activeInput = -1;

void updateInputs() {
  // Update Drag
  if (activeInput == 0) {
    drag.update();
    if (mousePressed) {
      camOffset.x = drag.getX();
      camOffset.y = drag.getY();
    }
  // Update Scroll Bar
  } else if (activeInput == 1) {
    hs.update();
    camRotation = hs.getPosPI();
  }
}

class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
  
  float getPosPI() {
    // Convert spos to be values between
    // 0 and 2PI
    return 2 * PI * spos / float(swidth);
  }
}

class XYDrag {
  float scaler;
  int loose;
  
  int x_init;
  int y_init;
  int x_offset;
  int y_offset;
  
  float camX_init;
  float camY_init;
  
  // Extent of Clickability
  int extentX;
  int extentY;
  int extentW;
  int extentH;
  
  XYDrag(float s, int l, int eX, int eY, int eW, int eH ) {
    scaler = s;
    loose = l;
    
    extentX = eX;
    extentY = eY;
    extentW = eW;
    extentH = eH;
  }
  
  boolean inExtents() {
    if (mouseX > extentX && mouseX < extentX+extentW && mouseY > extentY && mouseY < extentY+extentH) {
      return true; 
    } else {
      return false;
    }
  }
  
  void init() {
    x_init = mouseX;
    y_init = mouseY;
    camX_init = camOffset.x;
    camY_init = camOffset.y;
  }
  
  void update() {
    x_offset = mouseX - x_init;
    y_offset = mouseY - y_init;
  }
  
  float getX() {
    return camX_init + scaler*x_offset;
  }
  
  float getY() {
    return camY_init + scaler*y_offset;
  }
}

void mousePressed() {
  
  // Determine which output is active
  if (drag.inExtents()) {
    activeInput = 0;
  } else if (hs.overEvent()) {
    activeInput = 1;
  } else {
    activeInput = -1;
  }
  
  if (activeInput == 0) drag.init();
}

void mouseReleased() {
  activeInput = -1;
}