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

void setup() {
  size(1000, 1000);
  
  // An example Origin and Desination between which we want to know the shortest path
  //
  origin = new PVector(random(1.0)*width, random(1.0)*height);
  destination = new PVector(random(1.0)*width, random(1.0)*height);
  
  // An example gridded network of width x height (pixels) and node resolution (pixels)
  //
  int nodeResolution = 10;  // pixels
  int graphWidth = width;   // pixels
  int graphHeight = height; // pixels
  network = new Graph(graphWidth, graphHeight, nodeResolution);
  network.cullRandom(0.5); // Randomly eliminates 50% of the nodes in the network
  
  // An example pathfinder object used to derive the shortest path
  // setting enableFinder to "false" will bypass the A* algorithm
  // and return a result akin to "as the bird flies"
  //
  boolean enableFinder = true;
  finder = new Pathfinder(network);
  path = finder.findPath(origin, destination, enableFinder);
}

void draw() {
  background(0);
  
  // Displays the Graph in grayscale.
  // FORMAT: display(color, alpha)
  //
  network.display(50, 255);
  
  // Displays the path last calculated in Pathfinder.
  // The results are overridden everytime findPath() is run.
  // FORMAT: display(color, alpha)
  //
  boolean showVisited = false;
  finder.display(100, 150, showVisited);
  
}