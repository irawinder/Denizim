/*  Beacon Simulator, Ira Winder and Changing Environments, 2018
 *
 *  Beacon Simulator simulates and visualizes wireless 
 *  sensors. Sensors detect synthetic people that ambulate 
 *  through an urban environment.
 *
 */

String project = "Beacon Simulator\n\n" + "Ira Winder\nChanging Environments\n\n";

String description = "Simulates and visualizes wireless " +
                     "sensors. Sensors detect synthetic people that " +
                     "ambulate through an urban environment.";

// Class that contains our urban sensor simulation
Field city;

// Scrollbars (horizontal and vertical
HScrollbar hs;
VScrollbar vs;

// Drag Functions
XYDrag drag;

// Initiatizes program on startup
void setup() {

  // Run application at a specified pixel dimension
  size(1280, 800, P3D);
  surface.setResizable(true);
  
  /* Enable this code for a full screen demonstration
  // Run application to match native screen resolution
  fullScreen(P3D);
  */
  
  // Sets Color Mode to Hue, Saturation, and Brightness
  colorMode(HSB);
  
  // Initialize the environment
  city = new Field(800, 800, 50);
  
  // Initialize Horizontal Scrollbar
  hs = new HScrollbar(int(MARGIN*width), int((1-2*MARGIN)*height), int((1-2*MARGIN)*width), int(MARGIN*height), 5);
  camRotation = hs.getPosPI(); // (0 - 2*PI)
  
  // Initialize Vertical Scrollbar
  vs = new VScrollbar(width - int(2*MARGIN*height), int(MARGIN*height), int(MARGIN*height), int(0.3*height), 5);
  
  // Initialize Drag Funciton
  drag = new XYDrag(1.0, 7, 5, 5, width - 10, int(0.85*height) - 5);
  
}

// Runs on a loop after setup()
void draw() {
  background(bgColor);
  
  // Update mouse and keyboard inputs
  updateInputs();
  
  // Update Simulation Aspects
  for (Person p: city.people) {
    p.update();
  }
  
  // Draw 3D Graphics
  draw3D();

  //Draw 2D Graphics
  draw2D();
  
  
}

void draw2D() {
  // Temporarily Overrides 3D Graphics Settings
  camera();
  perspective();
  hint(DISABLE_DEPTH_TEST);
  
  // Draw Scroll Bars
  hs.display();
  vs.display();
  
  // Draw Help Text
  pushMatrix();
  translate(width/2, MARGIN*height);
  fill(lnColor, 255-baseAlpha);
  textAlign(CENTER, TOP);
  text("Press 'r' to reset camera position", 0, 0);
  popMatrix();
  
  // Draw Description
  pushMatrix();
  translate(MARGIN*height, MARGIN*height);
  fill(lnColor, 255-baseAlpha);
  textAlign(LEFT, TOP);
  text(project + description, 0, 0, 200, 0.9*height);
  popMatrix();
  
  hint(ENABLE_DEPTH_TEST);
}

void draw3D() {
  setCamera(city.boundary);
  
  pushMatrix();
  
  // Rotate Reference Frame
  translate(0.5*city.boundary.x, 0.5*city.boundary.y, 0.5*city.boundary.z);
  rotate(camRotation);
  translate(-0.5*city.boundary.x, -0.5*city.boundary.y, -0.5*city.boundary.z);
  
  // Translate Reference Frame
  translate(camOffset.x, camOffset.y, 0);
  
  // Draw 3D Objects
  city.render();
  
  popMatrix();
}