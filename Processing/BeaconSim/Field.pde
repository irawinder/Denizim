/*  The Field class is a container to manage the 
 *  synthetic environment that containes Population 
 *  and Sensor classes, among others.
 */

class Field {
  PVector boundary;
  
  Field(float l, float w, float h) {
    boundary = new PVector(l, w, h);
  }
  
  void render() {
    
    //Draw Bounding Box
    stroke(lnColor);
    fill(lnColor, baseAlpha);
    pushMatrix();
    translate(0.5*boundary.x, 0.5*boundary.y, 0.5*boundary.z);
    box(boundary.x, boundary.y, boundary.z);
    popMatrix();
    fill(lnColor);
    ellipse(0, 0, 20, 20);
  }
}

class Person {
  
}

class Sensor {
  
}