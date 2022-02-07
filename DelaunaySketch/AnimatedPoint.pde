class AnimatedPoint {
  PVector pos = new PVector();
  float bounceDuration;
  float bounceTime = 0;
  float size;
  public AnimatedPoint(float x, float y, float size) {
    pos.set(x, y);
    this.size = size;
  }
  
  void update(float timeStep) {
    if(bounceDuration > 0) {
      bounceTime += timeStep;
    }
  }
  
  void bounce(float duration) {
    bounceDuration = duration;
    bounceTime = 0;
  }
  
  float getSize() {
    if(bounceDuration <= 0) {
      return size;
    }
    
    float t = clamp01(bounceTime / bounceDuration);
    return outBack(t) * size;
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

  void draw() {
    circle(pos.x, pos.y, getSize());
  }
}
