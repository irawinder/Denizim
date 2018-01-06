/*  The Field class is a container to manage the 
 *  synthetic environment that containes Population 
 *  and Sensor classes, among others.
 */

class Field {
  // Bounding Box for Our Environment, Used to focus camera
  // Remember that (0,0) is in upper-left corner!
  PVector boundary;
  
  float BUFFER = 40; // feet
  float FADE_BUFFER = 10; // feet
  
  // Objects for importing data files such as CSVs and Graphics
  PImage map;
  
  // Block objects in our field
  ArrayList<Block> blocks;
  int selectedBlock = 0;
  boolean blockEditing = false;
  
  // Person objects in our field
  ArrayList<Person> people;
  
  Field(float l, float w, float h, PImage img) {
    boundary = new PVector(l, w, h);
    
    blocks = new ArrayList<Block>();
    Block b;
    for (int i=0; i<0; i++) {
      b = new Block();
      b.randomize(boundary.x, boundary.y, 50, 100);
      blocks.add(b);
    }
    
    people = new ArrayList<Person>();
    Person p;
    for (int i=0; i<900; i++) {
      p = new Person();
      p.randomize(boundary.x, boundary.y);
      people.add(p);
    }
    
    map = img;
  }
  
  void randomizeBlocks() {
    for(Block b: blocks) {
      b.randomize(boundary.x, boundary.y, 50, 100);
    }
  }
  
  void randomizePeople() {
    for(Person p: people) {
      p.randomize(boundary.x, boundary.y);
    }
  }
  
  void nextBlock() {
    if (selectedBlock == blocks.size() - 1) {
      selectedBlock = 0;
    } else {
      selectedBlock++;
    }
  }
  
  void removeBlock() {
    if (blocks.size() > 0) {
      blocks.remove(selectedBlock);
      if (selectedBlock > 0) {
        selectedBlock--;
      }
    }
  }
  
  void saveBlocks() {
    // Data file for saving/loading building objects
    Table blockTable = new Table();
    blockTable.addColumn();
    blockTable.addColumn();
    blockTable.addColumn();
    blockTable.addColumn();
    blockTable.addColumn();
    TableRow row;
    for (Block b: blocks) {
      row = blockTable.addRow();
      row.setFloat(0, b.loc.x);
      row.setFloat(1, b.loc.y);
      row.setFloat(2, b.l);
      row.setFloat(3, b.w);
      row.setFloat(4, b.h);
    }
    saveTable(blockTable, "data/" + cityIndex + "/blockTable.tsv");
    println(blocks.size() + " blocks saved.");
  }
  
  void loadBlocks(String name) {
    // Data file for saving/loading building objects
    Table blockTable = loadTable("data/" + name);
    
    blocks.clear();
    float x, y, l, w, h;
    Block b;
    for (int i=0; i<blockTable.getRowCount(); i++) {
      x = blockTable.getFloat(i, 0);
      y = blockTable.getFloat(i, 1);
      l = blockTable.getFloat(i, 2);
      w = blockTable.getFloat(i, 3);
      h = blockTable.getFloat(i, 4);
      b = new Block(x, y, l, w, h);
      blocks.add(b);
    }
    selectedBlock = 0;
    println(blockTable.getRowCount() + " blocks loaded.");
  }
  
  void render() {
    
    // Draw Bounding Box
    stroke(lnColor, 0.5*baseAlpha*uiFade);
    noFill();
    pushMatrix();
    translate(0.5*boundary.x, 0.5*boundary.y, 0.5*boundary.z);
    box(boundary.x, boundary.y, boundary.z);
    popMatrix();
    
    // Draw Ground
    pushMatrix();
    translate(0, 0, -1);
    if (map == null) {
      // Draw a Rectangle
      fill(50, 255 - baseAlpha);
      noStroke();
      rect(0, 0, boundary.x, boundary.y);
    } else {
      // Draw Ground Map
      tint(255, 255 - baseAlpha);
      image(map, 0, 0, boundary.x, boundary.y);
    }
    popMatrix();

    // Draw Some Buildings
    for(int i=0; i<blocks.size(); i++) {
      Block b = blocks.get(i);
      pushMatrix();
      translate(b.loc.x, b.loc.y, b.h/2);
      if (i == selectedBlock && blockEditing) {
        fill(#FFFF00, 2*baseAlpha);
      } else {
        fill(b.col, 2*baseAlpha);
      }
      box(b.l, b.w, b.h);
      popMatrix();
    }
    
    // Draw Some People
    for(Person p: people) {
      if (p.loc.x >= - BUFFER && p.loc.x <= boundary.x + BUFFER &&
          p.loc.y >= - BUFFER && p.loc.y <= boundary.y + BUFFER ) {
            
        pushMatrix();
        translate(p.loc.x, p.loc.y, p.h/2);
        
        float fadeX, fadeY, fadeVal;
        fadeX = abs(p.loc.x - boundary.x/2) - boundary.x/2;
        fadeY = abs(p.loc.y - boundary.y/2) - boundary.y/2;
        fadeVal = 1 - max(fadeX, fadeY) / BUFFER;
        if (fadeVal > 0) {
          fill(p.col, fadeVal*255);
        } else {
          fill(p.col);
        }
        box(p.l, p.w, p.h);
        popMatrix();
      }
    }
    
    // Draw Cursor
    if (blockEditing) {
      pushMatrix();
      translate(1.2*mouseX, 1.2*mouseY, 10);
      fill(lnColor);
      sphere(5);
      popMatrix();
    }
    
  }
}

class Person {
  PVector loc, vel, acc;
  float l, w, h; // length, width, and height
  float MAX_SPEED = 15.0; // pixels per second
  color col;
  
  Person() {
    loc = new PVector(0, 0);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    l = 2;
    w = 2;
    h = 6;
    MAX_SPEED /= 60.0; // convert from seconds to frames
    col = color(255);
  }
  
  void randomize(float x_max, float y_max) {
    loc.x = random(0, x_max);
    loc.y = random(0, y_max);
    col = color(random(10, 90), 255, 255, 200);
  }
  
  void update() {
    //acc = new PVector(random(-1, 1), random(-1, 1));
    //acc.setMag(random(-0.1, 0.1));
    acc.x += random(-1, 1);
    acc.y += random(-1, 1);
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
  
  Block(float x, float y, float l, float w, float h) {
    loc = new PVector(x, y);
    this.l = l;
    this.w = w;
    this.h = h;
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