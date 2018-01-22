/**
 Demonstration of using the Extrusion class to simulate 
 a buildings.
 
 created by Peter Lager
 */

import shapes3d.utils.*;
import shapes3d.animation.*;
import shapes3d.*;

float angleX, angleY, angleZ; // rotation of 3D shape
Extrusion e;

Path path;
Contour contour;
ContourScale conScale;

public void setup() {
  size(300, 300, P3D);
  cursor(CROSS);
  
  path = new P_LinearPath(new PVector(0, 80, 0), new PVector(0, 0, 0));
  contour = getBuildingContour();
  conScale = new CS_ConstantScale();
  // Create the texture coordinates for the end
  contour.make_u_Coordinates();
	// Create the extrusion
  e = new Extrusion(this, path, 1, contour, conScale);
  e.setTexture("wall_50alpha.png", 1, 1);
  e.drawMode(S3D.TEXTURE );
  // Extrusion end caps
  e.setTexture("wall_50alpha.png", S3D.E_CAP);
  e.setTexture("wall_50alpha.png", S3D.S_CAP);
  e.drawMode(S3D.TEXTURE, S3D.BOTH_CAP);
}

public void draw() {
  background(32, 32, 128);
  camera(0, 250, 250, 0, 0, 0, 0, -1, 0);
  lights();
  angleX += radians(0.913f);
  angleY += radians(0.799f);
  angleZ += radians(1.213f);
  e.rotateTo(angleX, angleY, angleZ);
  e.draw();
}

public Contour getBuildingContour() {
  PVector[] c = new PVector[] {
    new PVector(-30, 30), 
    new PVector(30, 30), 
    new PVector(50, 10), 
    new PVector(10, -30), 
    new PVector(-10, -30), 
    new PVector(-50, 10)
    };
    return new Building(c);
}

// The extrusion contour must be from a class that
// extends the library Contour class.
public class Building extends Contour {

  public Building(PVector[] c) {
    this.contour = c;
  }
}