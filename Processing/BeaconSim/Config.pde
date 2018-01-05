// Default color for lines, text, etc
int lnColor = 255;  // (0-255)
// Default background color
int bgColor = 0;    // (0-255)
// Default baseline alpha value
int baseAlpha = 50; // (0-255)

float camRotation = 0; // (0 - 2*PI)

void invertColors() {
  lnColor = bgColor;
  bgColor = abs(lnColor - 255);
}

// Set Camera Position
void setCamera(PVector boundary) {
  float eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ;
  float zoom = 0.6;
  
  // Camera Position
  eyeX = boundary.x * +0.5;
  eyeY = zoom * boundary.y * -0.5;
  eyeZ = zoom * boundary.z * +10.0;
  
  // Point of Camera Focus
  centerX = 0.50 * boundary.x;
  centerY = 0.50 * boundary.y;
  centerZ = 0.50 * boundary.z;
  
  // Axes Directionality (Do not change)
  upX =   0;
  upY =   0;
  upZ =  -1;
  
  camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
  lights(); // Default Lighting Condition
}