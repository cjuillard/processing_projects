int numParticles = 50;
float particleSize = 10;
float minParticleRadius = 50;
float maxParticleRadius = 500;

int numCircles = 5;
int numPoints = 200;
float offsetSize = 200;
float noiseScl = .1f;
float globalNoiseOffset = 0;
float noiseOffsetDelta = .005f;
float noiseRadius = 1;
float radius = 250;

GIFSaver saver = new GIFSaver("perlin-loop");

void setup() {
  size(1024, 768);
}

float noiseLoop(float t, float radius, float z) {
  float a = TWO_PI * t;
  
  return noise(radius + cos(a) * radius, radius + sin(a) * radius, z);
}

float particleT = 0;

void GetWavyCircle(float t, PVector out, float noiseOffset) {
  float a = TWO_PI * t;
  float n = .5 + noiseLoop(t, noiseRadius, noiseOffset);
  float tmpRadius = n * radius;
  out.set(cos(a) * tmpRadius, sin(a) * tmpRadius);
}

void drawWavyCircle(float baseT, float noiseOffset) {
  noFill();
  stroke(255);
  PVector point = new PVector();
  beginShape();
  for(int i = 0; i < numPoints; i++) {
    
    float t = baseT + i / (float)numPoints;
    GetWavyCircle(t, point, noiseOffset);
    vertex(point.x, point.y);
  }
  endShape(CLOSE);
}


void drawParticle(float t, float z) {
  fill(255,255,255);
  float a = TWO_PI * t;
  float n = noiseLoop(t, noiseRadius, z);
  float tmpRadius = map(n, 0, 1, minParticleRadius, maxParticleRadius);
  circle(cos(a) * tmpRadius, sin(a) * tmpRadius, particleSize);
}

void draw() {
  background(102);
  globalNoiseOffset += noiseOffsetDelta;
  //println(noiseLoop(particleT, 10, 0));
  particleT += noiseOffsetDelta;
  float angleStep = TWO_PI / numPoints;
  
  pushMatrix();
  translate(width / 2, height / 2);
  
  for(int i = 0; i < numParticles; i++) {
    drawParticle(particleT + i / (float)numParticles, i);
  }
  
  //for(int i = 0; i < numCircles; i++) {
  for(int i = 0; i < 1; i++) {
    float n = noiseLoop(globalNoiseOffset, .25f, 0);
    drawWavyCircle(0, n * 10);
    //drawWavyCircle(0, globalNoiseOffset * 4 + i);
  }
  
  if(particleT < 1) {
    //saver.saveFrame();
  }
  //fill(255,0,0);
  //GetWavyCircle(0, point);
  //circle(point.x, point.y, 20);  
  
  //fill(0,255,0);
  //GetWavyCircle(1, point);
  //circle(point.x, point.y, 10);  
  popMatrix();
}
