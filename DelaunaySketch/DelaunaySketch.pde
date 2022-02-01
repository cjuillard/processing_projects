PoissonDiscSampling sampling;
DelaunayTriangulation triangulation = new DelaunayTriangulation();
ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<Triangle> tris = new ArrayList<Triangle>();
ArrayList<ArrayList<VTriangle>> voronoiPolys;

float scale = 1f;

PImage img;

void setup() {
  size(640, 640);
  //size(1280, 960);
  stroke(255);
  noFill();
  
  img = loadImage("../Loops2/Loop2/test.jpg");
  //sampling = new PoissonDiscSampling(width, height, 10);
  //sampling.genPoints(points);
  
  randomSeed(0);
  //sampling = new PoissonDiscSampling(width * scale, height * scale, 10);
  sampling = new PoissonDiscSampling(width * scale, height * scale, 50);
  sampling.genPoints(points);
  //genTestPoints();
  triangulation.bowyerWatson(points, tris);
  //voronoiPolys = new VoronoiDiagram().convertDelaunay(tris);
}

void genTestPoints() {
  points.clear();
  randomSeed(1);
  for(int i = 0; i < 50; i++) {
    points.add(new PVector(random(0,width), random(0,height)));
  }
}

void mouseClicked() {
  //for(int i = 0; i < 100 && points.size() > 0; i++) {
  //  points.remove((int)random(0, floor(points.size())));
  //}
  
  //triangulation.bowyerWatson(points, tris);
  //sampling.genPoints(points);
  
  //polyIndex = (polyIndex + 1) % voronoiPolys.size();
  //println(polyIndex + " / " + voronoiPolys.size());
  
  save("test.png");
}

float clamp01(float val) {
  return max(0, min(1, val));
}

void draw() {
  background(0);
  
  float offsetX = (width - sampling.worldWidth) * 0.5f;
  float offsetY = (height - sampling.worldHeight) * 0.5f;
  pushMatrix();
  translate(offsetX, offsetY);
  noFill();
  for(PVector p : points) {
    strokeWeight(4);
    stroke(255);
    //point(p.x, p.y);
  }
  
  strokeWeight(2);
  for(Triangle tri : tris) {
    
    strokeWeight(.1f);
    noStroke();
    
    float centerX = (tri.p1.x + tri.p2.x + tri.p3.x) / 3f;
    float centerY = (tri.p1.y + tri.p2.y + tri.p3.y) / 3f;
    int normX = floor(clamp01(centerX / sampling.worldWidth) * img.width);
    int normY = floor(clamp01(centerY / sampling.worldHeight) * img.height);
    color col = img.get(normX, normY);
    fill(col);
    
    //fill(tri.c);
    triangle(tri.p1.x, tri.p1.y, tri.p2.x, tri.p2.y, tri.p3.x, tri.p3.y);
    
    Circle c = tri.circumCenter;
    //circle(c.center.x, c.center.y, c.radius * 2);
  }
  
  //VoronoiDiagram diagram = new VoronoiDiagram();
  //for(ArrayList<VTriangle> poly : voronoiPolys) {
  //  diagram.drawPoly(poly);
  //}
  
  popMatrix();
}
