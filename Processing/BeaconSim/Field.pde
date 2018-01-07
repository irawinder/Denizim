/*  The Field class is a container to manage the 
 *  synthetic environment that containes Population 
 *  and Sensor classes, among others.
 */

class Field {
  // Bounding Box for Our Environment, Used to focus camera
  // Remember that (0,0) is in upper-left corner!
  PVector boundary;
  
  float BUFFER = 50; // feet
  
  // Objects for importing data files such as CSVs and Graphics
  PImage map;
  
  // Bounding Area(s) for Wandering Agents
  ArrayList<Fence> fences;
  int selectedFence = 0;
  boolean fenceEditing = false;
  
  // Path(s) for Wandering Agents
  ArrayList<Path> paths;
  int selectedPath = 0;
  boolean pathEditing = false;
  
  // Block objects in our field
  ArrayList<Block> blocks;
  int selectedBlock = 0;
  boolean blockEditing = false;
  
  // Sensor objects in our field
  ArrayList<Sensor> beacons;
  int selectedSensor = 0;
  boolean sensorEditing = false;
  
  // Person objects in our field
  ArrayList<Person> people;
  
  Field(float l, float w, float h, PImage img) {
    boundary = new PVector(l, w, h);
    
    paths = new ArrayList<Path>();
    Path p;
    p = new Path();
    p.randomPath(0, 0 ,boundary.x, boundary.y, 5);
    //fen = new Fence(0, 0, l, w);
    paths.add(p);
    
    fences = new ArrayList<Fence>();
    Fence fen;
    fen = new Fence(0.26*boundary.x, 0.32*boundary.y, 0.50*boundary.x, 0.38*boundary.y);
    //fen = new Fence(0, 0, l, w);
    fences.add(fen);
    
    blocks = new ArrayList<Block>();
    Block b;
    for (int i=0; i<0; i++) {
      b = new Block();
      b.randomize(boundary.x, boundary.y, 50, 100);
      blocks.add(b);
    }
    
    people = new ArrayList<Person>();
    randomizePeople();
    
    beacons = new ArrayList<Sensor>(); 
    randomBeacons(3);
    
    map = img;
  }
  
  void randomBeacons(int num) {
    beacons.clear(); 
    Sensor s;
    for (int i=0; i<num; i++) {
      s = new Sensor();
      s.randomize(0.22*boundary.x, 0.27*boundary.y, 0.58*boundary.x, 0.43*boundary.y, s.DIAM/2, s.DIAM/2);
      beacons.add(s);
    }
  }
  
  void randomizeBlocks() {
    for(Block b: blocks) {
      b.randomize(boundary.x, boundary.y, 50, 100);
    }
  }
  
  void randomizePeople() {
    people.clear();
    Person p;
    Fence fen = fences.get(0);
    for (int i=0; i<900; i++) {
      p = new Person();
      p.randomize(fen.x, fen.y, fen.l, fen.w);
      if (random(1.0) < 0.1) {
        if (freezeVisitCounter) {
          p.numDetects = 2;
        } else {
          p.numDetects = 1;
        }
      }
      people.add(p);
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
    if (map == null || !drawMap) {
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
    
    // Draw Beacons
    for(Sensor s: beacons) {
      pushMatrix();
      translate(s.loc.x, s.loc.y, -5);
      noStroke();
      fill(s.col);
      sphere(s.DIAM);
      popMatrix();
    }
    
    // Draw Buildings
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
    
    // Draw People
    for(Person p: people) {
      // Only Draw People Within Bounds
      Fence fen = fences.get(0);
      if (p.loc.x > fen.x - BUFFER && p.loc.x < fen.x + fen.l + BUFFER &&
          p.loc.y > fen.y - BUFFER && p.loc.y < fen.y + fen.w + BUFFER ) {
            
        pushMatrix();
        translate(p.loc.x, p.loc.y, p.h/2);
        
        // Determine Color
        float scale;
        color col;
        float vis;
        if (p.detected) {
          //col = p.col;
          vis = min(1, p.numDetects-1) / 1.0;
          col = color(150 - 50*vis, 255, 255);
          scale = 1.5;
        } else {
          col = color(255, baseAlpha);
          scale = 1.0;
        }
        
        // Determine Fade
        float fadeX, fadeY, fadeVal;
        fadeX = abs(p.loc.x - fen.x - fen.l/2) - fen.l/2;
        fadeY = abs(p.loc.y - fen.y - fen.w/2) - fen.w/2;
        fadeVal = 1 - max(fadeX, fadeY) / BUFFER;
        
        // Apply Fade, Color, and Draw Person
        if (fadeVal > 0) {
          fill(col, fadeVal*255);
        } else {
          fill(col);
        }
        box(scale*p.l, scale*p.w, scale*p.h);
        
        popMatrix();
      }
    }
    
    float beaconFade = sq(1 - float(frameCounter) / PING_FREQ);
    
    // Draw Paths
    Path p;
    int numNodes;
    PVector n1, n2;
    stroke(lnColor);
    for (int i=0; i<paths.size(); i++) {
      p = paths.get(i);
      numNodes = p.nodes.size();
      if (numNodes > 1) {
        for (int j=1; j<numNodes; j++) {
          n1 = p.nodes.get(j-1);
          n2 = p.nodes.get(j);
          line(n1.x, n1.y, n2.x, n2.y);
        }
      }
    }
    
    // Draw Beacon Min Range
    for(Sensor s: beacons) {
      pushMatrix();
      translate(s.loc.x, s.loc.y, -5);
      noStroke();
      if (beaconFade > 0.1) {
        fill(lnColor, beaconFade*baseAlpha);
        sphere(2*s.MIN_RANGE);
      }
      popMatrix();
    }
    
    // Draw Beacon Max Range
    if (beaconFade > 0.1) {
      hint(DISABLE_DEPTH_TEST);
      for(Sensor s: beacons) {
        pushMatrix();
        translate(s.loc.x, s.loc.y, 0);
        noStroke();
        fill(lnColor, beaconFade*0.5*baseAlpha);
        ellipse(0, 0, 2*s.MAX_RANGE, 2*s.MAX_RANGE);
        popMatrix();
      }
      hint(ENABLE_DEPTH_TEST);
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
  boolean detected = false;
  int numDetects;
  
  Person() {
    loc = new PVector(0, 0);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    l = 2;
    w = 2;
    h = 6;
    MAX_SPEED /= 60.0; // convert from seconds to frames
    col = color(255);
    
    if (freezeVisitCounter) {
      numDetects = 1;
    } else {
      numDetects = 0;
    }
  }
  
  void randomize(float x, float y, float l, float w) {
    loc.x = random(x, x+l);
    loc.y = random(y, y+w);
    col = color(random(50, 100), 255, 255, 200);
  }
  
  void update(Field f) {
    //acc = new PVector(random(-1, 1), random(-1, 1));
    //acc.setMag(random(-0.1, 0.1));
    acc.x += random(-1, 1);
    acc.y += random(-1, 1);
    vel.add(acc);
    if (vel.mag() > MAX_SPEED) vel.setMag(MAX_SPEED);
    loc.add(vel);
    
    Fence fen = f.fences.get(0);
    if (loc.x < fen.x - f.BUFFER) 
      loc.x = fen.x + fen.l + f.BUFFER;
    if (loc.x > fen.x + fen.l + f.BUFFER) 
      loc.x = fen.x - f.BUFFER;
    if (loc.y < fen.y - f.BUFFER) 
      loc.y = fen.y + fen.w + f.BUFFER;
    if (loc.y > fen.y + fen.w + f.BUFFER) 
      loc.y = fen.y - f.BUFFER;
  }
}

class Sensor {
  PVector loc;
  float l, w, h; // length, width, and height
  color col;
  int DIAM = 10;
  float MIN_RANGE = 0.5*75;  // ft
  float MAX_RANGE = 0.5*450; // ft
  
  Sensor() {
    loc = new PVector(0, 0);
    l = DIAM;
    w = DIAM;
    h = DIAM;
    col = soofaColor;
  }
  
  Sensor(float x, float y) {
    loc = new PVector(x, y);
    l = DIAM;
    w = DIAM;
    h = DIAM;
    col = soofaColor;
  }
  
  void randomize(float x_max, float y_max, float l_max, float w_max, float d_min, float d_max) {
    loc.x = random(x_max + d_max/2, x_max + l_max - d_max/2);
    loc.y = random(y_max + d_max/2, y_max + w_max - d_max/2);
    //col = color(random(100, 200), 255, 255);
  }
  
  void randomize(float x_max, float y_max, float d_min, float d_max) {
    loc.x = random(d_max/2, x_max - d_max/2);
    loc.y = random(d_max/2, y_max - d_max/2);
    //col = color(random(100, 200), 255, 255);
  }
  
  // Determines if a nearby person is being detected by sensor
  boolean detect(PVector pos, boolean currentlyReading) {
    PVector d = new PVector(pos.x-loc.x, pos.y-loc.y);
    float distance = d.mag();
    boolean detect = false;
    if (distance > MAX_RANGE) {
      detect = false;
    } else if (currentlyReading) {
      detect = true;
    } else if (distance <= MIN_RANGE) {
      detect = true;
    } else if (distance <= MAX_RANGE && distance > MIN_RANGE) {
      float probability =  pow(1.0 - (distance - MIN_RANGE) / (MAX_RANGE - MIN_RANGE), 3);
      if (random(1.0) < probability) {
        detect = true;
      } else {
        detect = false;
      }
    }
    return detect;
  }
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

// Specifies a boundary condition for People Agents
class Fence {
  float x, y, l, w;
  
  Fence(float x, float y, float l, float w) {
    this.x = x;
    this.y = y;
    this.l = l;
    this.w = w;
  }
}

// Specifies a path condition for People Agents
class Path {
  ArrayList<PVector> nodes;
  
  Path() {
    nodes = new ArrayList<PVector>();
  }
  
  void randomPath(float x, float y, float l, float w, int num) {
    nodes.clear();
    PVector n;
    for (int i=0; i<num; i++) {
      n = new PVector(random(x, x+l), random(y, y+w));
      nodes.add(n);
    }
  }
}
  