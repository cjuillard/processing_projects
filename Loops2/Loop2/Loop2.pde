GIFSaver saver = new GIFSaver("loop");
boolean saveFrames = false;
int subdivisions = 40;
  
  
void setup()
{
  size(500,500,P3D);
}

int numFrames = 60;

float sizePeriodicFunc(float p)
{
  return map(sin(TWO_PI*p),-1,1,2,8);
}

float xDeltaPeriodicFunc(float p) {
   return map(sin(TWO_PI*p),-1,1,-25,25);
}

float offset(float x,float y)
{
  return 0.01*dist(x,y,width/2,height/2);
}

float angleOffset(float x,float y)
{
  float a = atan2(height/2 - y, width/2 - x);
  return 7*map(a, -PI, PI, 0, 1);
}

float noiseLoop(float t, float radius, float z) {
  float a = TWO_PI * t;
  
  return noise(radius + cos(a) * radius, radius + sin(a) * radius, z);
}

void draw()
{
  background(255);
  
  //drawLoop();
  drawWaves();  
 
  if(saveFrames && saver.currFrame <= numFrames) {
    saver.saveFrame(); 
  }
}

float offsetWavy(float x,float y) {
  return 0.01*dist(x,y,width/2,height/2);
  //return .01f * x + .016f * y;
}

void drawWaves() {
  float t = frameCount/(float)numFrames;
  
  stroke(0);
  
  pushMatrix();
  //rotateZ(PI/2f);
  //camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  //camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  rotateX(PI/6f);

  fill(255);
  PVector p0 = new PVector();
  PVector p1 = new PVector();
  PVector p2 = new PVector();
  PVector p3 = new PVector();
  strokeWeight(1);
  beginShape(QUADS);
  for(int i=0;i<subdivisions;i++)
  {
    for(int j=0;j<subdivisions;j++)
    {
      getWavyPos(i,j,t,p0);
      getWavyPos(i,j+1,t,p1);
      getWavyPos(i+1,j+1,t,p2);
      getWavyPos(i+1,j,t,p3);
      
      vertex(p0.x, p0.y, p0.z);
      vertex(p1.x, p1.y, p1.z);
      vertex(p2.x, p2.y, p2.z);
      vertex(p3.x, p3.y, p3.z);
      //float x = map(i,0,m-1,0,width);
      //float y = map(j,0,m-1,0,height);
      
      //float tOffset = offsetWavy(x,y);
      //float offsetT = t-tOffset;
      //float size = map(sin(TWO_PI * offsetT),-1,1,1,20);
      ////float size = sizePeriodicFunc(t-tOffset);
      ////strokeWeight(size);
      
      //float zOffset = map(sin(TWO_PI * offsetT) + cos(TWO_PI * offsetT * 2) * .23f + sin(TWO_PI * offsetT * 3) * .1f,-1,1,1,20);
      //size = width/(float)subdivisions;
      //float sizeH = size / 2f;
      //float xs = x - sizeH;
      //float ys = y - sizeH;
      ////pushMatrix();
      ////translate(x,y,zOffset);
      ////quad(xs, ys, xs, ys + size, xs + size, ys + size, xs + size, ys);
      ////box(size);
      ////popMatrix();
    }
  }
  endShape();
  
  strokeWeight(5);
  beginShape(POINTS);
  float noiseScl = .3f;
  for(int i=0;i<subdivisions;i++)
  {
    for(int j=0;j<subdivisions;j++)
    {
      //if(noise(i*noiseScl,j*noiseScl) < .5f)
      //  continue;
        
      getWavyPos(i,j,t,p0);
      getWavyPos(i,j+1,t,p1);
      getWavyPos(i+1,j+1,t,p2);
      getWavyPos(i+1,j,t,p3);
      
      //vertex((p0.x + p2.x) * 0.5f, (p0.y + p2.y) * 0.5f, (p0.z + p2.z) * .5f);
    }
  }
  endShape();
  
  hint(DISABLE_DEPTH_TEST);
  beginShape(LINES);
  for(int i=0;i<subdivisions;i++)
  {
    for(int j=0;j<subdivisions;j++)
    {
      if(j % 2 == 0) continue;
      if(noise(i*noiseScl,j*noiseScl) < .5f)
        continue;
      
      float periodic = sin(t*TWO_PI);
      getWavyPos(i+0.5f,j+0.5f + periodic,t,p0);
      getWavyPos(i+0.5f,j+1.5f + periodic,t,p1);
      vertex(p0.x, p0.y, p0.z + .1f);
      vertex(p1.x, p1.y, p1.z + .1f);
      //getWavyPos(i,j+1,t,p1);
      //getWavyPos(i+1,j+1,t,p2);
      //getWavyPos(i+1,j,t,p3);
      
      //vertex((p0.x + p2.x) * 0.5f, (p0.y + p2.y) * 0.5f, (p0.z + p2.z) * .5f);
    }
  }
  endShape();
  
  hint(ENABLE_DEPTH_TEST);
  popMatrix();
}
void getWavyPos(float i, float j, float t, PVector output) {
  float x = map(i,0,subdivisions,0,width);
  float y = map(j,0,subdivisions,0,height);
      
  float tOffset = offsetWavy(x,y);
  float offsetT = t-tOffset;
  
  //float zOffset = map(sin(TWO_PI * offsetT) + cos(TWO_PI * offsetT * 2) * .23f + sin(TWO_PI * offsetT * 3) * .1f,-1,1,1,50);
  float zOffset = map(sin(TWO_PI * offsetT),-1,1,1,50);
  
  output.set(x,y,zOffset);
}

void drawLoop() {
  float t = frameCount/(float)numFrames;
  
  int m = 40;
  
  stroke(0);
  
  for(int i=0;i<m;i++)
  {
    for(int j=0;j<m;j++)
    {
      float x = map(i,0,m-1,0,width);
      float y = map(j,0,m-1,0,height);
      
      float tOffset = offset(x,y);
      float size = sizePeriodicFunc(t-tOffset);
      strokeWeight(size);
      
      float xOff = xDeltaPeriodicFunc(t-tOffset);
      float yOff = xDeltaPeriodicFunc(t-tOffset+.25f);
      
      
      float angleOffset = angleOffset(x,y);
      float newXOff = xDeltaPeriodicFunc(t-angleOffset);
      float newYOff = xDeltaPeriodicFunc(t-angleOffset + .25f);
      
      //point(x+xOff,y+yOff);  // Spiral
      //point(x +newXOff,y + newYOff);  // Star
      point(x +newXOff + xOff,y + newYOff + yOff);  // Flower-ish
    }
  } 
}
