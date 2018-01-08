/*  Beacon Simulator, Ira Winder and Changing Environments, 2018
 *
 *  Beacon Simulator simulates and visualizes wireless 
 *  sensors. Sensors detect synthetic people that ambulate 
 *  through an urban environment.
 *
 */

String version = "Beta 1.0";

String project = "Soofa Spaces Simulator, " + version + "\n" + "Changing Environments\n\n";

String description = "Soofa sensors can collect anonymized " +
                     "data to help cities understand visitor behavior. ";

// Scrollbars (horizontal and vertical
HScrollbar hs;
VScrollbar vs;

// Drag Functions
XYDrag drag;

// Initiatizes program on startup
void setup() {

  // Run application at a specified pixel dimension
  //size(1280, 800, P3D);
  
  // Run application to match native screen resolution
  fullScreen(P3D);
  
  // Sets Color Mode to Hue, Saturation, and Brightness
  colorMode(HSB);
  
  // Initialize the environment
  initFields();
  
  // Initialize the Camera
  initCamera();
  
  // Initialize Horizontal Scrollbar
  hs = new HScrollbar(int(MARGIN*width), int((1-2*MARGIN)*height), int((1-2*MARGIN)*width), int(MARGIN*height), 5);
  camRotation = hs.getPosPI(); // (0 - 2*PI)
  
  // Initialize Vertical Scrollbar
  vs = new VScrollbar(width - int(2*MARGIN*height), int(MARGIN*height), int(MARGIN*height), int(0.3*height), 5);
  
  // Initialize Drag Funciton
  drag = new XYDrag(1.0, 7, 5, 5, width - 10, int(0.85*height) - 5);
  
  resetControls();
}

// Runs on a loop after setup()
void draw() {
  background(bgColor);
  
  // Update mouse and keyboard inputs
  updateInputs();
  
  // Update Simulation Aspects
  Field f = city.get(cityIndex);
  
  for (Person p: f.people) {
    p.update(personLocations(f.people), true);
    p.update(f);
    
    if (frameCounter == 0) {
      if (!p.detected) {
        for (Sensor s: f.beacons) {
          p.detected = s.detect(p.loc, p.detected);
          if (p.detected) {
            if (!freezeVisitCounter) p.numDetects++;
            break;
          }
        }
      } else {
        boolean check = false;
        for (Sensor s: f.beacons) {
          if(s.detect(p.loc, p.detected)) check = true;
        }
        if (!check) p.detected = false;
      }
    }
  }
  
  // Draw 3D Graphics
  draw3D(f);

  // Draw 2D Graphics
  draw2D();
  
  //Count Frames
  if (frameCounter < PING_FREQ - 1) {
    frameCounter++;
  } else {
    frameCounter = 0;
  }
  
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
  fill(lnColor, uiFade*(255-baseAlpha));
  textAlign(CENTER, TOP);
  text("Press 'r' to reset camera position", 0, 0);
  popMatrix();
  
  
  pushMatrix();
  // Draw Help Canvas
  translate(MARGIN*height, MARGIN*height);
  fill(lnColor, baseAlpha);
  rect( -5, -5, 220, 325, 10);
  // Draw Logo (1500 x 719)
  translate(10, 0);
  image(logo, 0, 0, 0.1*1500, 0.1*719);
  // Draw Description
  translate(0, 0.15*719);
  fill(lnColor);
  textAlign(LEFT, TOP);
  text(project + description + "\n\nLegend:", 0, 0, 200, 0.9*height);
  //Draw Legend
  translate(0, 128);
  //DrawShadows
  fill(0);
  rect(1, 1 +  0, 4, 12, 3);
  rect(1, 1 + 28, 4, 12, 3);
  rect(1, 1 + 56, 4, 12, 3);
  //DrawPeople
  fill(100);
  stroke(lnColor, baseAlpha);
  rect(0, 0 +  0, 4, 12, 3);
  noStroke();
  fill(150, 255, 255);
  rect(0, 0 + 28, 4, 12, 3);
  fill(100, 255, 255);
  rect(0, 0 + 56, 4, 12, 3);
  //DrawText
  fill(lnColor);
  text("Undetected Visitor\n\nNew Visitor\n\nReturning Visitor", 10, -1);
  popMatrix();
  
  
  hint(ENABLE_DEPTH_TEST);
}

void draw3D(Field f) {
  setCamera(f.boundary);
  
  pushMatrix();
  
  // Rotate Reference Frame
  translate(0.5*f.boundary.x, 0.5*f.boundary.y, 0.5*f.boundary.z);
  rotate(camRotation);
  translate(-0.5*f.boundary.x, -0.5*f.boundary.y, -0.5*f.boundary.z);
  
  // Translate Reference Frame
  translate(camOffset.x, camOffset.y, 0);
  
  // Draw 3D Objects
  f.render();
  
  popMatrix();
}