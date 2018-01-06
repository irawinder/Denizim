float camRotation;
float MAX_ZOOM;
float MIN_ZOOM;
float CAMX_DEFAULT;
float CAMY_DEFAULT;
float camZoom;
PVector camOffset;

void initCamera() {
  camRotation = 0; // (0 - 2*PI)
  MAX_ZOOM = 0.1;
  MIN_ZOOM = 2.0;
  CAMX_DEFAULT = 0;
  CAMY_DEFAULT = - 0.12 * city.get(cityIndex).boundary.y;
  camZoom = 0.6;
  camOffset = new PVector(CAMX_DEFAULT, CAMY_DEFAULT);
}

// Set Camera Position
void setCamera(PVector boundary) {
  float eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ;
  
  // Camera Position
  eyeX = boundary.x * 0.5;
  eyeY = (camZoom/MIN_ZOOM - 0.5) * boundary.y;
  eyeZ = camZoom * boundary.z * boundary.x / 75;
  
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