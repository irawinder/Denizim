/*  Beacon Simulator, Ira Winder 2018
 *
 *  Beacon Simulator simulates and visualizes wireless 
 *  sensors placed in an urban environment. Sensors detect 
 *  synthetic people that ambulate through an environment.
 *
 */

Field city;

// Initiatizes program on startup
void setup() {
  
  // Run application at a specified pixel dimension
  size(1280, 800, P3D);
  surface.setResizable(true);
  
  /*
  // Run application to match native screen resolution
  fullScreen();
  */
  
  city = new Field(400, 400, 50);
  
  

}

// Runs on a loop after setup()
void draw() {
  background(bgColor);
  
  setCamera(city.boundary);
  city.render();
}