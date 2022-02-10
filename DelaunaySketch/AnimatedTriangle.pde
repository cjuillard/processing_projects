class AnimatedTriangle {
  Triangle tri;
  PVector p1Pixel = new PVector();
  PVector p2Pixel = new PVector();
  PVector p3Pixel = new PVector();
  float drawDuration;
  float drawTime = 0;
  float r,g,b;
  public AnimatedTriangle(Triangle tri, color c) {
    this.tri = tri;
    r = red(c);
    g = green(c);
    b = blue(c);
    worldToPixel(tri.p1, p1Pixel);
    worldToPixel(tri.p2, p2Pixel);
    worldToPixel(tri.p3, p3Pixel);
  }
  
  boolean update(float timeStep) {
    boolean completedAnim = false; 
    if(drawDuration > 0) {
      float prevTime = drawTime;
      drawTime += timeStep;
      if(prevTime < drawDuration && drawTime >= drawDuration) {
        completedAnim = true;
      }
    }
    
    return completedAnim;
  }
  
  boolean isAnimationComplete() {
    return drawDuration > 0 && drawTime > drawDuration;
  }
  
  void startAnimation() {
    drawDuration = random(.35f, .75f);
    drawTime = 0;
  }
  
  void draw() {
    if(drawDuration <= 0)
      return;
    
    float t = clamp01(drawTime / drawDuration);
    noStroke();
    fill(lerp(255, r, t), lerp(255, g, t), lerp(255, b, t), 255);
    triangle(p1Pixel.x, p1Pixel.y, p2Pixel.x, p2Pixel.y, p3Pixel.x, p3Pixel.y);
  }
  
  
}
