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
    stroke(lnColor, baseAlpha);
    noFill();
    box(boundary.x, boundary.y, boundary.z);
  }
}

class Person {
  
}

class Sensor {
  
}