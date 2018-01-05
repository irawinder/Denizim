/*  Beacon Simulator, Ira Winder 2018
 *
 *  Beacon Simulator simulates and visualizes wireless 
 *  sensors placed in an urban environment. Sensors detect 
 *  synthetic people that ambulate through an environment.
 *
 */

// Class that contains our urban sensor simulation
Field city;

// Scrollbar
HScrollbar hs;

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
  
  // Initialize scrollbar
  hs = new HScrollbar(0, 0.975*height, width, int(0.05*height), 5);
}

// Runs on a loop after setup()
void draw() {
  background(bgColor);
  
  hs.update();
  camRotation = hs.getPosPI();
  
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
  
  // Draw Scroll Bar
  hs.display();
  
  hint(ENABLE_DEPTH_TEST);
}

void draw3D() {
  setCamera(city.boundary);
  
  pushMatrix();
  translate(0.5*city.boundary.x, 0.5*city.boundary.y, 0.5*city.boundary.z);
  rotate(camRotation);
  translate(-0.5*city.boundary.x, -0.5*city.boundary.y, -0.5*city.boundary.z);

  city.render();
  
  popMatrix();
}