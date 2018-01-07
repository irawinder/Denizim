/*  PATHFINDER ALGORITHMS
 *  Ira Winder, ira@mit.edu
 *  Coded w/ Processing 2 (Java)
 *
 *  The Main Tab "PathfinderBasic" shows an example implementation of 
 *  algorithms useful for finding shortest pathes snapped to a gridded 
 *  network. Explore the 'classes' tab to see how they work.
 */

// Objects to define our Network
ObstacleCourse course;
Graph network;
Pathfinder finder;

// Objects to define and capture a specific origin, destiantion, and path
PVector origin, destination;
ArrayList<PVector> path;

// Objects to define agents that navigate our environment;
ArrayList<Agent> people;

void initEnvironment() {
  // An example gridded network of width x height (pixels) and node resolution (pixels)
  //
  int nodeResolution = 10;  // pixels
  int graphWidth = width;   // pixels
  int graphHeight = height; // pixels
  network = new Graph(graphWidth, graphHeight, nodeResolution);
  network.cullRandom(0.5); // Randomly eliminates 50% of the nodes in the network
}

void initPopulation() {
  // An example Origin and Desination between which we want to know the shortest path
  //
  origin = new PVector(random(1.0)*width, random(1.0)*height);
  destination = new PVector(random(1.0)*width, random(1.0)*height);
  
  // An example pathfinder object used to derive the shortest path
  // setting enableFinder to "false" will bypass the A* algorithm
  // and return a result akin to "as the bird flies"
  //
  boolean enableFinder = true;
  finder = new Pathfinder(network);
  path = finder.findPath(origin, destination, enableFinder);
  
  // An example population that traverses along shortest path calculation
  // FORMAT: Agent(x, y, radius, speed, path);
  Agent person;
  PVector loc;
  int random_index;
  float random_speed;
  people = new ArrayList<Agent>();
  for (int i=0; i<50; i++) {
    random_index = int(random(path.size()-1));
    random_speed = random(0.1, 0.3);
    loc = path.get(random_index);
    person = new Agent(loc.x, loc.y, 5, random_speed, path);
    people.add(person);
  }
}

void setup() {
  size(1000, 1000);
  initEnvironment();
  initPopulation();
}

void draw() {
  background(0);
  
  // Displays the Graph in grayscale.
  //
  tint(255, 75); // overlaid as an image
  image(network.img, 0, 0);
  
  // Displays the path last calculated in Pathfinder.
  // The results are overridden everytime findPath() is run.
  // FORMAT: display(color, alpha)
  //
  boolean showVisited = false;
  finder.display(100, 150, showVisited);
  
  // Update and Display the population of agents
  // FORMAT: display(color, alpha)
  //
  boolean collisionDetection = true;
  for (Agent p: people) {
    p.update(people, collisionDetection);
    p.display(#FFFF00, 150);
  }
  
  textAlign(CENTER, CENTER);
  fill(255);
  text("Press any key to regenerate path", width/2, height/2);
  
}

void keyPressed() {
  initPopulation();
}