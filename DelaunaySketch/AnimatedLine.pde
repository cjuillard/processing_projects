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
  
  void startAnimation() {
    drawDuration = random(.35f, .75f);
    drawTime = 0;
  }
  
  // Code based off of https://github.com/AurelienRibon/universal-tween-engine ...
  //protected float param_s = 1.70158f;  // original
  protected float param_s = 6.70158f;  // amplified
  public final float inBack(float t) {
    float s = param_s;
    return t*t*((s+1)*t - s);
  }
  
  public final float outBack(float t) {
    float s = param_s;
    return (t-=1)*t*((s+1)*t + s) + 1;
  }
  
  public final float inOutBack(float t) {
    float s = param_s;
    if ((t*=2) < 1) return 0.5f*(t*t*(((s*=(1.525f))+1)*t - s));
    return 0.5f*((t-=2)*t*(((s*=(1.525f))+1)*t + s) + 2);
  }
  
  PVector tmpP = new PVector();
  void draw() {
    if(drawDuration <= 0)
      return;
    
    strokeWeight(sWeight);
    stroke(255);
    float t = clamp01(drawTime / drawDuration);
    if(t >= 1) {
      line(p1Pixel.x, p1Pixel.y, p2Pixel.x, p2Pixel.y);
    } else {
      tmpP.set(p2Pixel).sub(p1Pixel).mult(t);
      tmpP.add(p1Pixel);
      
      line(p1Pixel.x, p1Pixel.y, tmpP.x, tmpP.y);
    }
  }
  
  
}
