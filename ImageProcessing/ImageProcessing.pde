GIFSaver saver = new GIFSaver("processed_image");
boolean saveFrames = true;
int numFrames = 1;

IDrawable drawable;
  
void setup()
{
  size(1000,1000,P3D);
  
  //drawable = new DotSurface();
  //drawable = new MaskedDots();
  //drawable = new SampledLines();
  drawable = new SampledOther();
}

void mouseClicked() {
  loop();
}
  
void draw()
{
  //background(255);
  
  drawable.draw();
  
  if(saveFrames && saver.currFrame <= numFrames) {
    saver.saveFrame(); 
  }
}
