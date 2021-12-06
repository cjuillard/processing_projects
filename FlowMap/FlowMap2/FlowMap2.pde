//int scl = 10;
//int rows = width / scl;
//int cols = height / scl;
//PVector[][] flowField = new PVector[rows][cols];
int scl;
int rows;
int cols;
PVector[][] flowField;
ArrayList<Particle> particles = new ArrayList<Particle>();
int NumParticles = 500;
float flowStrength = .05;
int iterationCount = 10;
float noiseOffset = random(100);
float noiseScale = .3;
float noiseRange = 1;
float seedIterations = 100;

void setup() {
  size(2048, 1157);
  scl = 50;
  rows = height / scl;
  cols = width / scl;
  flowField = new PVector[cols][rows];
  
  for(int x = 0; x < cols; x++){
     for(int y = 0; y < rows; y++) {
       flowField[x][y] = PVector.fromAngle(noise(noiseOffset + x * noiseScale, noiseOffset + y * noiseScale) * TWO_PI * noiseRange)
         .mult(flowStrength);
     }
  }
  
  for(int i = 0; i < NumParticles; i++) {
    Particle p = new Particle();
    p.Pos.x = random(width);
    p.Pos.y = random(height);
    p.Velocity.x = random(-1, 1);
    p.Velocity.y = random(-1, 1);
    particles.add(p);
  }
  
  fill(255,255,255,255);
  rect(0,0,width,height);
  
  for(int i = 0; i < seedIterations; i++) {
    for(Particle p : particles) {
      PVector f = GetForce(p.Pos);
      p.Velocity.add(f);
      p.update();
    }  
  }
}

void mouseClicked() {
   saveFrame(); 
}

PVector tmpDir = new PVector();
void drawFlowField() {
  for(int x = 0; x < cols; x++) {
    for(int y = 0; y < rows; y++) {
      tmpDir.set(flowField[x][y]);
      tmpDir.normalize();
      line(x * scl, y * scl, 
          (x + tmpDir.x * .5f) * scl, (y + tmpDir.y * .5f) * scl);
          
      
      //line(x * scl, y * scl, 
      //    x * scl + 20, y * scl + 100);
      
      //ellipse(x * scl, y * scl, 5, 5);
    }
  }
}

enum DrawType {
  Debug,
  BlackAndWhite,
  Hue,
}
float currHue = 0;
void draw() {
  
  DrawType drawType = DrawType.Hue;
  switch(drawType) {
   case Debug:
       clear();
       stroke(255);
       drawFlowField();
       break;
    case BlackAndWhite:
      fill(0,0,0,2);
      noStroke();
      break;
  }
   
  
  for(int i = 0; i < iterationCount; i++) {
    switch(drawType) {
      case Hue:
        colorMode(HSB, 255, 255, 255, 255);
        color c = color(currHue, 255, 255, 4);
        fill(c);
        noStroke();
        currHue+=.1f;
        currHue %= 256;
        break;
    }
    for(Particle p : particles) {
      PVector f = GetForce(p.Pos);
      p.Velocity.add(f);
      //p.Pos.add(f);
      p.update();
      p.draw(); 
    }  
  }
  
}

PVector GetForce(PVector pos) {
   int x = constrain(round(pos.x / scl), 0, cols-1);
   int y = constrain(round(pos.y / scl), 0, rows-1);
   return flowField[x][y];
}
