/**
 * Bezier. 
 * 
 * The first two parameters for the bezier() function specify the 
 * first point in the curve and the last two parameters specify 
 * the last point. The middle parameters set the control points
 * that define the shape of the curve. 
 */

float r = 10;
float k = 30;
float w = r / sqrt(2);
PVector[] grid;
ArrayList<PVector> active = new ArrayList<PVector>();
void setup() {
  size(640, 640); 
  stroke(255);
  noFill();
  
  
  int cols = floor(width / w);
  int rows = floor(height / w);
  grid = new PVector[cols * rows];
  //for(int i = 0; i < grid.length; i++) {
  //  grid[i] ;
  //}
  
  // Insert first position
  float x = random(width);
  float y = random(height);
  int i = floor(x / w);
  int j = floor(y / w);
  PVector pos = new PVector(x,y);
  grid[i + j * cols] = pos;
  active.add(pos);
}



void draw() {
  background(0);
  
  for(int i = 0; i < grid.length; i++) {
    PVector p = grid[i];
    if(p == null)
      continue;
    
    strokeWeight(4);
    stroke(255);
    point(p.x, p.y);
  }
  
  //strokeWeight(4);
  //for(int i = 0; i < 1000; i++) {
  //  stroke(255);
  //  point(random(width), random(height));
  //}
  
  //for (int i = 0; i < 200; i += 20) {
  //  bezier(mouseX-(i/2.0), 40+i, 410, 20, 440, 300, 240-(i/16.0), 300+(i/8.0));
  //}
}
