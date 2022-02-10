class AnimatedLine {
  PVector p1 = new PVector();
  PVector p2 = new PVector();
  PVector p1Pixel = new PVector();
  PVector p2Pixel = new PVector();
  float drawDuration;
  float drawTime = 0;
  float sWeight;
  public AnimatedLine(PVector p1, PVector p2, float sWeight) {
    this.p1.set(p1);
    this.p2.set(p2);
    worldToPixel(p1, p1Pixel);
    worldToPixel(p2, p2Pixel);
    this.sWeight = sWeight;
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
  
  PVector tmpP = new PVector();
  void draw() {
    if(drawDuration <= 0)
      return;
    
    
    float t = clamp01(drawTime / drawDuration);
    float fadeTime = 0.5f;
    float weight = lerp(sWeight, 0, clamp01((drawTime - drawDuration) / fadeTime));
    if(weight == 0)
      return;
    strokeWeight(weight);
    stroke(255);
    if(t >= 1) {
      line(p1Pixel.x, p1Pixel.y, p2Pixel.x, p2Pixel.y);
    } else {
      tmpP.set(p2Pixel).sub(p1Pixel).mult(t);
      tmpP.add(p1Pixel);
      
      line(p1Pixel.x, p1Pixel.y, tmpP.x, tmpP.y);
    }
  }
  
  
}
