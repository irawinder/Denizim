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
    noFill();
    pushMatrix();
    translate(0.5*boundary.x, 0.5*boundary.y, 0.5*boundary.z);
    box(boundary.x, boundary.y, boundary.z);
    popMatrix();
    
    //Draw Some Grass
    fill(grassColor, 2*baseAlpha);
    noStroke();
    rect(20, 20, boundary.x - 40, boundary.y - 40);
  }
}

class Person {
  
}

class Sensor {
  
}