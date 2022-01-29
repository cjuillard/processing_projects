PoissonDiscSampling sampling;
DelaunayTriangulation triangulation = new DelaunayTriangulation();
ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<Triangle> tris = new ArrayList<Triangle>();

float scale = .5f;

void setup() {
  size(640, 640); 
  stroke(255);
  noFill();
  
  //sampling = new PoissonDiscSampling(width, height, 10);
  //sampling.genPoints(points);
  
  randomSeed(0);
  sampling = new PoissonDiscSampling(width * scale, height * scale, 10);
  sampling.genPoints(points);
  
  triangulation.bowyerWatson(points, tris);
}

void mouseClicked() {
  //points.remove(random(0, floor(points.size())));
  //triangulation.bowyerWatson(points, tris);
  //sampling.genPoints(points);
}

void draw() {
  background(0);
  
  float offsetX = (width - sampling.worldWidth) * 0.5f;
  float offsetY = (height - sampling.worldHeight) * 0.5f;
  pushMatrix();
  translate(offsetX, offsetY);
  for(PVector p : points) {
    strokeWeight(4);
    stroke(255);
    point(p.x, p.y);
  }
  
  strokeWeight(2);
  for(Triangle tri : tris) {
    strokeWeight(1);
    triangle(tri.p1.x, tri.p1.y, tri.p2.x, tri.p2.y, tri.p3.x, tri.p3.y);
    
    Circle c = tri.circumCenter;
    //circle(c.center.x, c.center.y, c.radius * 2);
  }
  
  popMatrix();
}
