PoissonDiscSampling sampling;
ArrayList<PVector> points = new ArrayList<PVector>();

void setup() {
  size(640, 640); 
  stroke(255);
  noFill();
  
  sampling = new PoissonDiscSampling(width, height, 10);
  sampling.genPoints(points);
}

void mouseClicked() {
  sampling.genPoints(points);
}

void draw() {
  background(0);
  
  for(PVector p : points) {
    strokeWeight(4);
    stroke(255);
    point(p.x, p.y);
  }
}
