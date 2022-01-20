
public class Segment {
  PVector a;
  float angle = 0;
  float len;
  PVector b = new PVector();
  Segment parent = null;
  
  public Segment(float x, float y, float len, float angle) {
    a = new PVector(x,y);
    this.angle = angle;
    this.len = len;
    calculateB();
  }
  
  public Segment(Segment parent, float len, float angle) {
    this.parent = parent;
    a = parent.b.copy();
    this.angle = angle;
    this.len = len;
    follow(parent.a.x, parent.a.y);
    calculateB();
  }
  
  void setA(PVector pos) {
    a = pos.copy();
    calculateB();
  }
  
  void calculateB() {
    float dx = len * cos(angle);
    float dy = len * sin(angle);
    b.set(a.x + dx, a.y + dy);
  }
  
  void follow(float tx, float ty) {
    PVector target = new PVector(tx, ty);
    PVector dir = PVector.sub(target, a);
    angle = dir.heading();
    
    dir.setMag(len);
    dir.mult(-1);
    a = PVector.add(target, dir);
  }
  
  void update() {
    calculateB();
  }
  
  void show() {
    stroke(255);
    line(a.x, a.y, b.x, b.y);
  }
}
