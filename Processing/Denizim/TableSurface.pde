// The following scripts Allow for the Display and Manipulation of a Tactile Matrix Grid

TableSurface matrix;

/*      ---------------> + U-Axis
 *     |
 *     |
 *     |
 *     |
 *     |
 *     |
 *   + V-Axis
 *
 */

// Data Extents Parameters

  // Display Matrix Size (cells rendered to screen)
  int U_MAX = 22;
  int V_MAX = 22;

void setupTable() {
  offscreen = createGraphics(projectorHeight, projectorHeight);
  // TableSurface(int u, int v, boolean left_margin)
  matrix = new TableSurface(projectorHeight, projectorHeight, V_MAX, V_MAX, true);
}

void drawTable() {

  // Draw the scene, offscreen
  matrix.draw(offscreen);

  if (testProjectorOnScreen) {
    stroke(0);
    strokeWeight(1);
    fill(255, 100);
    
    int screenFit = int(0.8*height);
    float boarderFit = 1.0625;
    
    rect( (width - boarderFit*screenFit) / 2, (height - boarderFit*screenFit) / 2, boarderFit*screenFit, boarderFit*screenFit, 10);
    image(offscreen, (width - screenFit) / 2, (height - screenFit) / 2, screenFit, screenFit);
    
    matrix.mouseToGrid((width - screenFit) / 2, (height - screenFit) / 2, screenFit, screenFit);
  }
}

class TableSurface {

  int U, V;
  float cellW, cellH;
  boolean LEFT_MARGIN;
  int MARGIN_W = 0;  // Left Margin for Grid (in Lego Squares)
  int gridMouseU, gridMouseV;
  
  TableSurface(int W, int H, int U, int V, boolean left_margin) {
    this.U = U;
    this.V = V;
    LEFT_MARGIN = left_margin;
    
    cellW = float(W)/U;
    cellH = float(H)/V;   
    
    gridMouseU = -1;
    gridMouseV = -1;
  }
  
  // Converts screen-based mouse coordinates to table grid position represented on screen during "Screen Mode"
  PVector mouseToGrid(int mouseX_0, int mouseY_0, int mouseW, int mouseH) {
    PVector grid = new PVector();
    boolean valid = true;
    
    grid.x = float(mouseX - mouseX_0) / mouseW * U;
    grid.y = float(mouseY - mouseY_0) / mouseH * V;
    
    if (grid.x >=MARGIN_W && grid.x < U) {
      gridMouseU = int(grid.x);
    } else {
      valid = false;
    }
    
    if (grid.y >=0 && grid.y < V) {
      gridMouseV = int(grid.y);
    } else {
      valid = false;
    }
    
    if (!valid) {
      gridMouseU = -1;
      gridMouseV = -1;
    }
    
    return grid;
  }
  
  boolean mouseInGrid() {
    if (gridMouseU == -1 || gridMouseV == -1) {
      return false;
    } else {
      return true;
    }
  }
  
  void draw(PGraphics p) {
    int buffer = 30;
    
    p.beginDraw();
    //p.background(50);
    p.background(0);

    // Cycle through each table grid, skipping margin
    for (int u=0; u<U; u++) {
      for (int v=0; v<V; v++) {
        
        // Draw black edges where Lego grid gaps are
        p.noFill();
        p.stroke(0);
        p.strokeWeight(3);
        p.rect(u*cellW, v*cellH, cellW, cellH);
          
      }
    }
    
    // Draw Mouse-based Cursor for Grid Selection
    if (gridMouseU != -1 && gridMouseV != -1) {
      p.fill(255, 150);
      p.rect(gridMouseU*cellW, gridMouseV*cellH, cellW, cellH);
    }
    
    // Draw logo_C1, logo_MIT
    p.image(logo_C1, 0.5*buffer, 0.87*p.height + 2.5*buffer, 4.0*buffer, 2.0*buffer); 
    //p.image(logo_MIT, 0.5*buffer, 0.87*p.height + 0.5*buffer, 3.0*buffer, 1.4*buffer); 

    p.endDraw();
  }
}
