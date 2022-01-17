public class MaskedDots implements IDrawable {
  public MaskedDots() {
  }
  
  public void draw() {
    float t = frameCount/(float)numFrames;
    background(255);
    
    noStroke();
    
    //stroke(255);
    fill(0);
    
    randomSeed(1);
    for(int i = 0; i < 100; i++) {
      float x = random(width);
      float y = random(height);
      
      float radius = random(50, 500);
      float a = TWO_PI * t + random(TWO_PI);
      circle(x + cos(a) * radius, y + sin(a) * radius, 20);
      
      //stroke(0);
      float offset = -TWO_PI * .01f;
      circle(x + cos(a + offset) * radius, y + sin(a + offset) * radius, 8);
      //noStroke();
    }
    
    //rect(0,0,width,height);
    
    //drawInverseCircleMask();
    drawCheckboardMask();
    //fill(255);
    //stroke(0);
    //rect(0,0,width,height);
    //rect(0,0,width,height);
    //rect(0,0,width,height);
    //rect(0,0,width,height);
    //rect(0,0,width,height);
    //rect(0,0,width,height);
    //rect(0,0,width,height);
    
    // 
  }
  
  void drawInverseCircleMask() {
    for(int x = 0; x < width; x++) {
      for(int y = 0; y < height; y++) {
        float dist = dist(x, y, width / 2, height / 2);
        float a = map(dist, 0, width / 2.5f, 0, 255);
        fill(255,255,255,a);
        //point(x,y);
        rect(x,y,1,1);
      }
    }
  }
  
  void drawCheckboardMask() {
    float t = frameCount/(float)numFrames;
    
    int tiles = 5;
    float tileWidth = width / tiles;
    float tileHeight = height / tiles;
    for(int x = 0; x < width; x++) {
      for(int y = 0; y < height; y++) {
        int tileX = floor(x / tileWidth);
        int tileY = floor(y / tileHeight);
        
        float normalX = (x - tileX * tileWidth) / tileWidth;
        float normalY = (y - tileY * tileHeight) / tileHeight;
        float a = 1;
        if(tileY % 2 == 0) {
          if(tileX % 2 == 0) {
            if(sin(normalX * PI + t * TWO_PI) > 0)
              a = 255;
            else 
              a = 0;  
          } else {
             a = 0; 
          }
          
          //a = (tileX % 2 == 0) ? 255 : 0;
        } else {
          if(tileX % 2 == 1) {
            if(sin(normalX * PI + -t * TWO_PI + PI) > 0)
              a = 255;
            else 
              a = 0;  
          } else {
             a = 0; 
          } 
          //a = (tileX % 2 == 0) ? 0 : 255;
        }
        //float a = map(dist, 0, width / 2.5f, 0, 255);
        fill(255,255,255,a);
        //point(x,y);
        rect(x,y,1,1);
      }
    }
  }
}
