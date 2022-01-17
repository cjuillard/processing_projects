int numLines = 2000000;   
float strokeMin = 1;
float strokeMax = 6;

public class SampledLines implements IDrawable {
  PImage img;
  public SampledLines() {
    img = loadImage("../Loops2/Loop2/test.jpg");
    //img = loadImage("test1.tif");
    //img = loadImage("test2.tif");
    //img = loadImage("test3.tif");
    //img = loadImage("test4.tif");
  }
  
  public void draw() {
   noLoop();
  
   background(255); 
   
   //noStroke();
   float scaleAmount = 1;
   float imgAspect = img.width / (float)height;
   float windowAspect = width / (float)height;
   if(imgAspect > windowAspect) {
     scaleAmount = img.width / (float)width;
   } else {
     scaleAmount = img.height / (float)height; 
   }
   
   float minLineLength = width / 30;
   float maxLineLength = width / 10;
   for(int i = 0; i < numLines; i++) {
     float x = random(0,width);
     float y = random(0,height);
     
     strokeWeight(random(strokeMin, strokeMax));
     float lineLength = random(minLineLength, maxLineLength);
     float theta = random(0,TWO_PI);
     float x1 = x - cos(theta) * lineLength * 0.5f;
     float y1 = y - sin(theta) * lineLength * 0.5f;
     float x2 = x + cos(theta) * lineLength * 0.5f;
     float y2 = y + sin(theta) * lineLength * 0.5f;
     
     color c = img.get(round(x*scaleAmount),round(y*scaleAmount));
     float average = (red(c) + green(c) + blue(c)) / 3f;
     //if(random(0, 255) > average) {
     //  stroke(0); 
     //} else {
     //   stroke(255); 
     //}
     stroke(c,100);
     line(x1, y1, x2, y2);
   }
  }
}

public class SampledOther implements IDrawable {
  PImage img;
  public SampledOther() {
    img = loadImage("test.jpg");
    //img = loadImage("test1.tif");
    //img = loadImage("test2.tif");
    //img = loadImage("test3.tif");
    //img = loadImage("test4.tif");
  }
  
  public void draw() {
   noLoop();
  
   background(255); 
   
   //noStroke();
   float scaleAmount = 1;
   float imgAspect = img.width / (float)height;
   float windowAspect = width / (float)height;
   if(imgAspect > windowAspect) {
     scaleAmount = img.width / (float)width;
   } else {
     scaleAmount = img.height / (float)height; 
   }
   
   float minLineLength = width / 30;
   float maxLineLength = width / 10;
   for(int i = 0; i < numLines; i++) {
     float x = random(0,width);
     float y = random(0,height);
     
     strokeWeight(random(strokeMin, strokeMax));
     float lineLength = random(minLineLength, maxLineLength);
     float theta = random(0,TWO_PI);
     float x1 = x - cos(theta) * lineLength * 0.5f;
     float y1 = y - sin(theta) * lineLength * 0.5f;
     float x2 = x + cos(theta) * lineLength * 0.5f;
     float y2 = y + sin(theta) * lineLength * 0.5f;
     
     color c = img.get(round(x*scaleAmount),round(y*scaleAmount));
     float average = (red(c) + green(c) + blue(c)) / 3f;
     
     stroke(c,100);
     //quad(x1, y1, x2, y1, x2, y2, x1, y2);
     //circle(x, y, lineLength);
     line(x1, y1, x2, y2);
   }
  }
}
