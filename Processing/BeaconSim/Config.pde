// Global Constants and Configuration for Application

// Fraction of screen height to use as margin
float MARGIN = 0.03;

// Bounding Dimensions of Environment (unitless / pixels)
float FIELD_L = 800;
float FIELD_W = 800;
float FIELD_H = 50;

// Default color for lines, text, etc
int lnColor = 255;  // (0-255)
// Default background color
int bgColor = 0;    // (0-255)
// Default baseline alpha value
int baseAlpha = 50; // (0-255)
// Default Grass Color
int grassColor = #95AA13;

// Number to apply to UI transparency
float uiFade = 1.0;  // 0.0 - 1.0

void invertColors() {
  lnColor = bgColor;
  bgColor = abs(lnColor - 255);
}

float camRotation = 0; // (0 - 2*PI)
float MAX_ZOOM = 0.1;
float MIN_ZOOM = 2.0;
float CAMX_DEFAULT = 0;
float CAMY_DEFAULT = - 0.12 * FIELD_L;
float camZoom = 0.6;
PVector camOffset = new PVector(CAMX_DEFAULT, CAMY_DEFAULT);

// Set Camera Position
void setCamera(PVector boundary) {
  float eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ;
  
  // Camera Position
  eyeX = boundary.x * 0.5;
  eyeY = (camZoom/MIN_ZOOM - 0.5) * boundary.y;
  eyeZ = camZoom * boundary.z * 10.0;
  
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