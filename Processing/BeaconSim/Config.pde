// Default color for lines, text, etc
int lnColor = 255;  // (0-255)
// Default background color
int bgColor = 0;    // (0-255)
// Default baseline alpha value
int baseAlpha = 50; // (0-255)

void invertColors() {
  lnColor = bgColor;
  bgColor = abs(lnColor - 255);
}

// Set Camera Position
void setCamera(PVector boundary) {
  float eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ;
  float zoom = 0.8;
  
  // Camera Position
  eyeX = zoom * boundary.x;
  eyeY = zoom * boundary.y;
  eyeZ = zoom * boundary.z * 10;
  
  // Point of Camera Focus
  centerX = 0.25 * boundary.x;
  centerY = 0.25 * boundary.y;
  centerZ = 0.50 * boundary.z;
  
  // Axes Directionality (Do not change)
  upX =   0;
  upY =   0;
  upZ = - 1;
  
  camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
  lights(); // Default Lighting Condition
}