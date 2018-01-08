/*  PATHFINDER ALGORITHMS
 *  Ira Winder, ira@mit.edu
 *  Coded w/ Processing 2 (Java)
 *
 *  The Main Tab "PathfinderBasic" shows an example implementation of 
 *  algorithms useful for finding shortest pathes snapped to a gridded 
 *  network. Explore the 'classes' tab to see how they work.
 */

// Objects to define our Network
//
ObstacleCourse course;
Graph network;
Pathfinder finder;

//  Object to define and capture a specific origin, destiantion, and path
//
ArrayList<Path> paths;

//  Objects to define agents that navigate our environment
//
ArrayList<Agent> people;

void initEnvironment() {
  //  An example gridded network of width x height (pixels) and node resolution (pixels)
  //
  int nodeResolution = 10;  // pixels
  int graphWidth = width;   // pixels
  int graphHeight = height; // pixels
  network = new Graph(graphWidth, graphHeight, nodeResolution);
  network.cullRandom(0.5); // Randomly eliminates 50% of the nodes in the network
}

void initPopulation() {
  //  An example pathfinder object used to derive the shortest path
  //  setting enableFinder to "false" will bypass the A* algorithm
  //  and return a result akin to "as the bird flies"
  //
  finder = new Pathfinder(network);
  
  //  FORMAT 1: Path(float x, float y, float l, float w)
  //  FORMAT 2: Path(PVector o, PVector d)
  //
  paths = new ArrayList<Path>();
  Path p;
  PVector origin, destination;
  for (int i=0; i<50; i++) {
    //  An example Origin and Desination between which we want to know the shortest path
    //
    origin = new PVector(random(1.0)*width, random(1.0)*height);
    destination = new PVector(random(1.0)*width, random(1.0)*height);
    p = new Path(origin, destination);
    p.solve(finder);
    paths.add(p);
  }
  
  //  An example population that traverses along shortest path calculation
  //  FORMAT: Agent(x, y, radius, speed, path);
  //
  Agent person;
  PVector loc;
  int random_waypoint;
  float random_speed;
  people = new ArrayList<Agent>();
  Path random;
  for (int i=0; i<1000; i++) {
    random = paths.get( int(random(paths.size())) );
    if (random.waypoints.size() > 1) {
      random_waypoint = int(random(random.waypoints.size()));
      random_speed = random(0.1, 0.3);
      loc = random.waypoints.get(random_waypoint);
      person = new Agent(loc.x, loc.y, 5, random_speed, random.waypoints);
      people.add(person);
    }
  }
}

void setup() {
  size(1000, 1000);
  initEnvironment();
  initPopulation();
}

void draw() {
  background(0);
  
  //  Displays the Graph in grayscale.
  //
  tint(255, 75); // overlaid as an image
  image(network.img, 0, 0);
  
  //  Displays the path last calculated in Pathfinder.
  //  The results are overridden everytime findPath() is run.
  //  FORMAT: display(color, alpha)
  //
  //boolean showVisited = false;
  //finder.display(100, 150, showVisited);
  
  //  Displays the path properties.
  //  FORMAT: display(color, alpha)
  //
  for (Path p: paths) {
    p.display(100, 50);
  }
  
  //  Update and Display the population of agents
  //  FORMAT: display(color, alpha)
  //
  boolean collisionDetection = true;
  for (Agent p: people) {
    p.update(personLocations(people), collisionDetection);
    p.display(#FFFF00, 150);
  }
  
  textAlign(CENTER, CENTER);
  fill(255);
  text("Press any key to regenerate path", width/2, height/2);
  
}

ArrayList<PVector> personLocations(ArrayList<Agent> people) {
  ArrayList<PVector> l = new ArrayList<PVector>();
  for (Agent a: people) {
    l.add(a.location);
  }
  return l;
}

void keyPressed() {
  initPopulation();
}