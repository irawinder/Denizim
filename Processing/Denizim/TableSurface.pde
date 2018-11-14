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

  PImage low_res, dash;

void setupTable() {
  offscreen = createGraphics(projectorHeight, projectorHeight);
  // TableSurface(int u, int v, boolean left_margin)
  matrix = new TableSurface(projectorHeight, projectorHeight, V_MAX, V_MAX, true);
  
  low_res = loadImage("0/low_res.png");
  dash = loadImage("0/dashboard.png");
}

void renderTable() {
  // Draw the scene, offscreen
  matrix.draw(offscreen);
}

void drawTable() {

  if (testProjectorOnScreen) {
    stroke(0);
    strokeWeight(1);
    fill(255, 100);
    
    int screenFit = int(0.8*height);
    float boarderFit = 1.0625;
    
    rect( (width - boarderFit*screenFit) / 2, (height - boarderFit*screenFit) / 2, boarderFit*screenFit, boarderFit*screenFit, 10);
    image(offscreen, (width - screenFit) / 2, (height - screenFit) / 2, screenFit, screenFit);
    
    //matrix.mouseToGrid((width - screenFit) / 2, (height - screenFit) / 2, screenFit, screenFit);
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
    
//    // Draw Mouse-based Cursor for Grid Selection
//    if (gridMouseU != -1 && gridMouseV != -1) {
//      p.fill(255, 150);
//      p.rect(gridMouseU*cellW, gridMouseV*cellH, cellW, cellH);
//    }
    
    p.fill(255);
    p.textSize(60);
    p.text("Hudson Yards Development Phasing (2018 - 2022)\nPedestrian Impact Analysis", 50, 100);
    
    p.textSize(100);
    p.fill(#FFFFCC);
    p.text("" + (yearIndex+2018), 50, p.height - 300);
    
    Field f = city.get(cityIndex);
    
    float canvas_per_map = float(p.width)/f.map.width;
    p.pushMatrix();
    p.translate(0, 0.5*(p.height - canvas_per_map*f.map.height));
    if (f.showPaths) {
      p.image(f.network.img, 0, 0, p.width, canvas_per_map*f.map.height);
    } else {
      p.image(f.map, 0, 0, p.width, canvas_per_map*f.map.height);
    }
    
//    float canvas_per_map = float(p.width)/low_res.width;
//    p.translate(0, 0.5*(p.height - canvas_per_map*low_res.height));
//    p.image(low_res, 0, 0, p.width, canvas_per_map*low_res.height);
    
//    p.translate(0, 0.5*(p.height - f.map.height));
//    p.image(f.map, 0, 0);
    
    canvas_per_map = float(p.width)/f.map.width;
    
    // Draw People
    p.noStroke();
    for(Person pl: f.people) {
      // Only Draw People Within Bounds
      p.pushMatrix();
      p.translate(canvas_per_map*pl.loc.x, canvas_per_map*pl.loc.y);
      
      // Determine Color
      float scale;
      color col;

      col = color(#00CAFF);
      scale = 1.0;
      
      p.fill(col, 100);
      //if (!p.pathFinding) fill(#FF0000);
      p.ellipse(0, 0, scale*10, scale*10);
      
      p.popMatrix();
    }
    
    for(int i=0; i<f.blocks.size(); i++) {
      Block b = f.blocks.get(i);
      p.pushMatrix();
      p.translate(canvas_per_map*b.loc.x, canvas_per_map*b.loc.y);
      if (b.h > 0 && yearIndex >= b.year-2018) {
        p.noStroke();
        p.fill(b.col, 200);
        p.rect(-0.5*canvas_per_map*b.l, -0.5*canvas_per_map*b.w, canvas_per_map*b.l, canvas_per_map*b.w);
      }
      p.popMatrix();
    }
    
    p.popMatrix();
    
    // Draw logo_C1, logo_MIT
    p.image(logo_C1, 50, p.height - 200, 250, 100); 
    p.image(dash, 500, p.height - 400, 1150, 435);
    //p.image(logo_MIT, 50, p.height - 400, 250, 100); 

    

    p.endDraw();
  }
}
