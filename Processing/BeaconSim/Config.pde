// Global Constants and Configuration for Application

// Fraction of screen height to use as margin
float MARGIN = 0.03;

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