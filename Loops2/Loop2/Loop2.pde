GIFSaver saver = new GIFSaver("loop");

void setup()
{
  size(500,500);
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
  
  float t = 1.0*frameCount/numFrames;
  
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
 
  if(saver.currFrame <= numFrames) {
    saver.saveFrame(); 
  }
}
