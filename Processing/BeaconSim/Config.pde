// Global Constants and Configuration for Application

float MARGIN = 0.03;

// Default color for lines, text, etc
int lnColor = 255;  // (0-255)
// Default background color
int bgColor = 0;    // (0-255)
// Default baseline alpha value
int baseAlpha = 50; // (0-255)
// Default Grass Color
int grassColor = #95AA13;

void invertColors() {
  lnColor = bgColor;
  bgColor = abs(lnColor - 255);
}

float camRotation = 0; // (0 - 2*PI)
float MAX_ZOOM = 0.1;
float MIN_ZOOM = 1.6;
float camZoom = 0.6;
PVector camOffset = new PVector(0,0);

// Set Camera Position
void setCamera(PVector boundary) {
  float eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ;
  
  // Camera Position
  eyeX = boundary.x * +0.5;
  eyeY = camZoom * boundary.y * -0.5;
  eyeZ = camZoom * boundary.z * +10.0;
  
  // Point of Camera Focus
  centerX = 0.50 * boundary.x;
  centerY = 0.50 * boundary.y;
  centerZ = -1.0 * boundary.z;
  
  // Axes Directionality (Do not change)
  upX =   0;
  upY =   0;
  upZ =  -1;
  
  camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
  lights(); // Default Lighting Condition
}