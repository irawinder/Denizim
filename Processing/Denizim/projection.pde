// This is a script that allows one to open a new canvas for the purpose 
// of simple 2D projection mapping, such as on a flat table surface
//
// Right now, only appears to work in windows...
//
// To use this example in the real world, you need a projector
// and a surface you want to project your Processing sketch onto.
//
// Simply press the 'c' key and drag the corners of the 
// CornerPinSurface so that they
// match the physical surface's corners. The result will be an
// undistorted projection, regardless of projector position or 
// orientation.
//
// You can also create more than one Surface object, and project
// onto multiple flat surfaces using a single projector.
//
// This extra flexbility can comes at the sacrifice of more or 
// less pixel resolution, depending on your projector and how
// many surfaces you want to map. 
//

import javax.swing.JFrame;
import deadpixel.keystone.*;

// Graphics Objects needed for Projection Mapping
Keystone ks;
CornerPinSurface surface;
PGraphics offscreen;
int projectorWidth, projectorHeight, projectorOffset;

// Visualization may show 2D projection visualization, or not
boolean displayProjection2D = false;
// When debugging without a projector (i.e. on Mac Laptop), this boolean allows table canvas to be shown on screen
boolean testProjectorOnScreen = false;

// New Application Window Parameters
PFrame proj2D = null; // f defines window to open new applet in
projApplet applet;    // applet acts as new set of setup() and draw() functions that operate in parallel

// Run Anything Needed to have Projection mapping work
void initializeProjection2D() {
  println("Projector Info: " + projectorWidth + ", " + projectorHeight + ", " + projectorOffset);
}

  // Turns Projection Mapping Applet On and Off
void toggle2DProjection() {
  if (System.getProperty("os.name").substring(0,3).equals("Mac")) {
    testProjectorOnScreen = !testProjectorOnScreen;
    println("Test on Mac = " + testProjectorOnScreen);
    println("Projection Mapping Currently not Supported for MacOS");
  } else {
    if (displayProjection2D) {
      displayProjection2D = false;
      closeProjection2D();
    } else {
      displayProjection2D = true;
      showProjection2D();
    }
  }
  
  println("displayProjection2D = " + displayProjection2D);
}

public class PFrame extends JFrame {
  public PFrame() {
    setBounds(0, 0, projectorWidth, projectorHeight );
    setLocation(projectorOffset, 0);
    applet = new projApplet();
    setResizable(false);
    setUndecorated(true); 
    setAlwaysOnTop(true);
    add(applet);
    applet.init();
    show();
    setTitle("Projection2D");
  }
}

// Open the Pojection Frame
public void showProjection2D() {
  if (proj2D == null) {
    proj2D = new PFrame();
  }
  proj2D.setVisible(true);
}

// Close the Projection Frame
public void closeProjection2D() {
  proj2D.setVisible(false);
}

// Throw out old Frame and start anew
public void resetProjection2D() {
  initializeProjection2D();
  if (proj2D != null) {
    proj2D.dispose();
    proj2D = new PFrame();
    if (displayProjection2D) {
      showProjection2D();
    } else {
      closeProjection2D();
    }
  }
}

// This is a new applet window, and operates like a separate processing thread with its own setup() and draw() functions
public class projApplet extends PApplet {
  public void setup() {
    // Keystone will only work with P3D or OPENGL renderers, 
    // since it relies on texture mapping to deform
    size(projectorWidth, projectorHeight, P2D);
    
    // Initialize projection-mapping objects
    ks = new Keystone(this);
    surface = ks.createCornerPinSurface(projectorHeight, projectorHeight, 20);

    offscreen = createGraphics(projectorHeight, projectorHeight);
    
    try{
      // Loads the corner position of a previously callibrated projection map
      ks.load();
    } catch(RuntimeException e){
      println("No Keystone.xml.  Save one first if you want to load one.");
    }
  }
  

  
  public void draw() {
    
    // Convert the mouse coordinate into surface coordinates
    // this will allow you to use mouse events inside the 
    // surface from your screen. 
//    PVector surfaceMouse = surface.getTransformedMouse();
    
    // most likely, you'll want a black background to minimize
    // bleeding around your projection area
    background(0);
    
    // Draw the scene, offscreen
    surface.render(offscreen);
  
  }
  
  void keyPressed() {
    switch(key) {
      case 'c':
        // enter/leave calibration mode, where surfaces can be warped 
        // and moved
        ks.toggleCalibration();
        break;
  
      case 'l':
        // loads the saved layout
        ks.load();
        break;
  
      case 's':
        // saves the layout
        ks.save();
        break;
      
      case '`': 
        if (displayProjection2D) {
          displayProjection2D = false;
          closeProjection2D();
        } else {
          displayProjection2D = true;
          showProjection2D();
        }
        break;
    }
  }
}
