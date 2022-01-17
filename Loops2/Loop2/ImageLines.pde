

public class ImageLines implements IDrawable {
  PImage img;
  public ImageLines() {
    img = loadImage("test.jpg");
  }
  
  public void draw() {
   float t = frameCount/(float)numFrames;
   background(255); 
   //imageMode(CENTER);
   //image(img, 0, 0, width, height);
   noStroke();
   float scaleAmount = 1;
   float imgAspect = img.width / (float)height;
   float windowAspect = width / (float)height;
   if(imgAspect > windowAspect) {
     scaleAmount = img.width / (float)width;
   } else {
     scaleAmount = img.height / (float)height; 
   }
   
   int sinWaveCount = 30;
   float numWaves = 15;
   float pixelsToRadians = numWaves * TWO_PI / height;
   float amplitude = 10;
   for(int sinWaveX = 0; sinWaveX < sinWaveCount; sinWaveX++) {
     float sinStartX = width / (float)sinWaveCount * sinWaveX;
     for(float y = 0; y < height; y += 0.5f) {
       float theta = y * pixelsToRadians + t * TWO_PI;
       float x = sinStartX + sin(theta) * amplitude;
       
       color c = img.get(round(x*scaleAmount),round(y*scaleAmount));
       
       //println(c);
       fill(c);
       //fill(10);
       circle(x,y, 5);
       //point(x,y);
     }
   }
  }
}
