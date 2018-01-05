/*  The Field class is a container to manage the 
 *  synthetic environment that containes Population 
 *  and Sensor classes, among others.
 */

class Field {
  // Bounding Box for Our Environment, Used to focus camera
  // Remember that (0,0) is in upper-left corner!
  PVector boundary;
  
  // Block objects in our field
  ArrayList<Block> blocks;
  
  // Person objects in our field
  ArrayList<Person> people;
  
  Field(float l, float w, float h) {
    boundary = new PVector(l, w, h);
    
    blocks = new ArrayList<Block>();
    Block b;
    for (int i=0; i<400; i++) {
      b = new Block();
      b.randomize(boundary.x, boundary.y, 5, 40);
      blocks.add(b);
    }
    
    people = new ArrayList<Person>();
    Person p;
    for (int i=0; i<900; i++) {
      p = new Person();
      p.randomize(boundary.x, boundary.y);
      people.add(p);
    }
  }
  
  void randomizeBlocks() {
    for(Block b: blocks) {
      b.randomize(boundary.x, boundary.y, 5, 40);
    }
  }
  
  void randomizePeople() {
    for(Person p: people) {
      p.randomize(boundary.x, boundary.y);
    }
  }
  
  void render() {
    
    // Draw Bounding Box
    stroke(lnColor, 0.5*baseAlpha*uiFade);
    noFill();
    pushMatrix();
    translate(0.5*boundary.x, 0.5*boundary.y, 0.5*boundary.z);
    box(boundary.x, boundary.y, boundary.z);
    popMatrix();
    
    // Draw Some Grass
    fill(50, 255 - baseAlpha);
    noStroke();
    pushMatrix();
    translate(0, 0, -1);
    rect(0, 0, boundary.x, boundary.y);
    popMatrix();

    // Draw Some Buildings
    for(Block b: blocks) {
      pushMatrix();
      translate(b.loc.x, b.loc.y, b.h/2);
      fill(b.col, 2*baseAlpha);
      box(b.l, b.w, b.h);
      popMatrix();
    }
    
    // Draw Some People
    for(Person p: people) {
      pushMatrix();
      translate(p.loc.x, p.loc.y, p.h/2);
      fill(p.col);
      box(p.l, p.w, p.h);
      popMatrix();
    }
    
  }
}

class Person {
  PVector loc, vel, acc;
  float l, w, h; // length, width, and height
  float MAX_SPEED = 30.0; // pixels per second
  color col;
  
  Person() {
    loc = new PVector(0, 0);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    l = 2;
    w = 2;
    h = 5;
    MAX_SPEED /= 60.0; // convert from seconds to frames
    col = color(255);
  }
  
  void randomize(float x_max, float y_max) {
    loc.x = random(0, x_max);
    loc.y = random(0, y_max);
    col = color(random(0, 100), 255, 255);
  }
  
  void update() {
    acc = new PVector(random(-1, 1), random(-1, 1));
    acc.setMag(random(-0.1, 0.1));
    vel.add(acc);
    if (vel.mag() > MAX_SPEED) vel.setMag(MAX_SPEED);
    loc.add(vel);
  }
}

class Sensor {
  
}

class Block {
  PVector loc;
  float l, w, h; // length, width, and height
  color col;
  
  Block() {
    loc = new PVector(0, 0);
    l = 0;
    w = 0;
    h = 0;
    col = color(255);
  }
  
  void randomize(float x_max, float y_max, float d_min, float d_max) {
    l = random(d_min, d_max);
    w = random(d_min, d_max);
    h = 2*d_max*sq(random(0.1, 1.1));
    loc.x = random(d_max/2, x_max - d_max/2);
    loc.y = random(d_max/2, y_max - d_max/2);
    col = color(random(100, 200), 255, 255);
  }
}