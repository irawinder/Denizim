/*  Beacon Simulator, Ira Winder 2018
 *
 *  Beacon Simulator simulates and visualizes wireless 
 *  sensors placed in an urban environment. Sensors detect 
 *  synthetic people that ambulate through an environment.
 *
 */

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
  
  // Initialize the environment
  city = new Field(400, 400, 50);
  
  float margin = 0.05;
  
  // Initialize Horizontal Scrollbar
  hs = new HScrollbar(int(margin*width), int((1-2*margin)*height), int((1-2*margin)*width), int(margin*height), 5);
  camRotation = hs.getPosPI(); // (0 - 2*PI)
  
  // Initialize Vertical Scrollbar
  vs = new VScrollbar(width - int(2*margin*height), int(margin*height), int(margin*height), int(0.3*height), 5);
  
  // Initialize Drag Funciton
  drag = new XYDrag(1.0, 16, 5, 5, width - 10, int(0.85*height) - 5);
  
}

// Runs on a loop after setup()
void draw() {
  background(bgColor);
  
  // Update mouse and keyboard inputs
  updateInputs();
  
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
  
  city.render();
  
  popMatrix();
}