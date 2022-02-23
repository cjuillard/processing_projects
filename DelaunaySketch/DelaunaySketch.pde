// Utilities
PoissonDiscSampling sampling;
VariablePoissonDiscSampling variableSampling;
DelaunayTriangulation triangulation = new DelaunayTriangulation();

// Core data
ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<Triangle> tris = new ArrayList<Triangle>();
ImageStats stats;
HashMap<PVector, ArrayList<Triangle>> vertexToTris = new HashMap<PVector, ArrayList<Triangle>>();

// Animation objects
HashMap<PVector, AnimatedPoint> animatedPoints = new HashMap<PVector, AnimatedPoint>();
HashMap<Edge, AnimatedLine> animatedLines = new HashMap<Edge, AnimatedLine>();
HashMap<Triangle, AnimatedTriangle> animatedTris = new HashMap<Triangle, AnimatedTriangle>();

float worldToPixel = 1;
float scale = 1f;
float worldPad = 100;
float worldWidth;
float worldHeight;
float frameLength = 1/30f;
PImage img;

// Controls
boolean saveFrames = false;
boolean drawTrisFill = false;
boolean drawTrisOutline = false;
boolean drawPoints = false;
boolean drawCircumCenters = false;
boolean drawImage = true;

void settings() {
  String[] paths = new String[] {
    "sample_images/1.jpg",
    "sample_images/2.jpg",
    "sample_images/3.jpg",
    "sample_images/3_tiny.jpg",
    "sample_images/3_standardsize.jpg",
    "test.png",
    "test_large.png",
    "test2.jpg",
    "test3.jpg",
  };
  loadSource(paths[2]);
}

void loadSource(String path) {
  img = loadImage(path);
  size(img.width, img.height);
}

void setup() {
  stroke(255);
  noFill();
  
  randomSeed(0);
  worldWidth = width * scale + 2 * worldPad;
  worldHeight = height * scale + 2 * worldPad;
  worldToPixel = 1;
  
  sampling = new PoissonDiscSampling(worldWidth, worldHeight, 15);
  sampling.genPoints(points);
  
  final float minRadius = 6;
  final float maxRadius = 50;
  final float sdDist = 4;
  RadiusProvider radiusProvider = new RadiusProvider() {
    private float minSDFound = Float.MAX_VALUE;
    private float maxSDFound = Float.MIN_VALUE;
    public float getRadius(float worldX, float worldY) {
      float sd = computeSD(worldX, worldY, sdDist);
      float minSD = 0;
      float maxSD = 50;
      float t = (sd - minSD) / (maxSD - minSD);
      t = clamp01(t);
      
      if(sd < minSDFound) {
        println("minSDFound = " + sd);
      }
      if(sd > maxSDFound) {
        println("maxSDFound = " + sd);
      }
      minSDFound = min(minSDFound, sd);
      maxSDFound = max(maxSDFound, sd);
      
      return lerp(maxRadius, minRadius, t);
      //return minRadius + (maxRadius - minRadius) * worldX / width;  // more sparse the further right we go
      //return 10;
      
    }
  };
  variableSampling = new VariablePoissonDiscSampling(worldWidth, worldHeight, minRadius, maxRadius, radiusProvider);
  variableSampling.genPoints(points);
  println("NumPoints generated: " + points.size()); 
  
  //genTestPoints();
  genTriangulationAndStats();
}

void genTriangulationAndStats() {
  triangulation.bowyerWatson(points, tris);
  
  stats = new ImageStats(img, tris);
  initVertToTris();
}

void initVertToTris() {
  vertexToTris.clear();
  
  for(Triangle tri : tris) {
    addVertToTris(tri.p1, tri);
    addVertToTris(tri.p2, tri);
    addVertToTris(tri.p3, tri);
  }
}

void addVertToTris(PVector p, Triangle tri) {
  ArrayList<Triangle> pTris = vertexToTris.get(p);
  if(pTris == null) {
    pTris = new ArrayList<Triangle>();
    vertexToTris.put(p, pTris);
  }
  pTris.add(tri);
}

void genTestPoints() {
  points.clear();
  randomSeed(1);
  for(int i = 0; i < 50; i++) {
    points.add(new PVector(random(0,width), random(0,height)));
  }
}

int getClosestPointIndexToMousePos() {
  PVector mousePos = new PVector(pixelToWorld(mouseX), pixelToWorld(mouseY));
  int minPosIndx = -1;
  float minDist = Float.MAX_VALUE;
  for(int i = 0; i < points.size(); i++) {
    PVector p = points.get(i);
    if(p.dist(mousePos) < minDist) {
      minDist = p.dist(mousePos);
      minPosIndx = i;
    }
  }
  
  return minPosIndx;
}
void mouseClicked() {
  
  if(mouseButton == LEFT) {
    int minPosIndx = getClosestPointIndexToMousePos();
    PVector p = points.get(minPosIndx);
    if(tryExpandingP(p)) {
      
    }
  } else if(mouseButton == RIGHT) {
    saveFrames = !saveFrames;
  }
}

void keyPressed()
{
  switch(key) {
    case '1': 
      drawTrisFill = !drawTrisFill; 
      break;
    case '2': 
      drawTrisOutline = !drawTrisOutline;
      break;
    case '3':
      drawPoints = !drawPoints;
      break;
    case '4':
      drawCircumCenters = !drawCircumCenters;
      break;
    case '5':
      drawImage = !drawImage;
      break;
    case 'r': 
      animatedPoints.clear();
      animatedLines.clear();
      animatedTris.clear();
      break;
  }
}

float clamp01(float val) {
  return max(0, min(1, val));
}

void draw() {
  if(drawImage) {
    image(img, 0, 0);
  } else {
    background(0);
  }
  
  
  pushMatrix();
  noFill();
  
  if(drawTrisFill || drawTrisOutline) drawTris();
  if(drawPoints) drawPoints();
  if(drawCircumCenters) drawCircumCenters();
  //drawClosestVertex();
  
  drawAnimatedTris();
  drawAnimatedLines();
  drawAnimatedPoints();
  
  popMatrix();
  
  if(saveFrames) {
    saveFrame("output/delaunay_####.png");
    fill(255, 0, 0);
  } else {
    fill(0, 255, 0);
  }
  ellipse(width / 2f, height - 50, 20, 20);
}

void drawTris() {
  PVector tmp1 = new PVector();
  PVector tmp2 = new PVector();
  PVector tmp3 = new PVector();
  
  if(drawTrisOutline) {
    strokeWeight(1);
    stroke(255);
  } else {
    noStroke();
  }
    
  if(!drawTrisFill) {
    noFill();
  }
  
    
  for(Triangle tri : tris) {
    
    worldToPixel(tri.p1, tmp1);
    worldToPixel(tri.p2, tmp2);
    worldToPixel(tri.p3, tmp3);
    
    TriangleStats triStats = stats.triStats.get(tri);
    if(drawTrisFill)
      fill(triStats.avgR, triStats.avgG, triStats.avgB);
    
    triangle(tmp1.x, tmp1.y, tmp2.x, tmp2.y, tmp3.x, tmp3.y);
  }
}

void drawCircumCenters() { 
  PVector tmp = new PVector();
  strokeWeight(.5f);
  stroke(255);
  noFill();
  for(Triangle tri : tris) {
    Circle c = tri.circumCenter;    
    worldToPixel(c.center, tmp);
    
    circle(tmp.x, tmp.y, c.radius * 2 * worldToPixel);
  }
}

void drawClosestVertex() {
  int posIndex = getClosestPointIndexToMousePos();
  if(posIndex != -1) {
    PVector closest = points.get(posIndex);
    fill(255,0,0);
    circle(worldToPixel(closest.x), worldToPixel(closest.y), 3);
  }
}

void drawPoints() {
  for(PVector p : points) {
    strokeWeight(4);
    stroke(255);
    point(worldToPixel(p.x), worldToPixel(p.y));
  }
}

void drawAnimatedPoints() {
  fill(0);
  stroke(255);
  strokeWeight(1);
  ArrayList<AnimatedPoint> pointsToExpand = new ArrayList<AnimatedPoint>();
  for(AnimatedPoint p : animatedPoints.values()) {
    boolean finishedAnim = p.update(frameLength);
    if(finishedAnim) {
      pointsToExpand.add(p);
    }
    p.draw();
  }
}

void drawAnimatedLines() {
  ArrayList<AnimatedLine> linesToExpand = new ArrayList<AnimatedLine>();
  for(AnimatedLine l : animatedLines.values()) {
    boolean finishedAnim = l.update(frameLength);
    if(finishedAnim) {
      linesToExpand.add(l);
    }
    l.draw();
  }
  
  for(AnimatedLine l : linesToExpand) {
    tryExpandingP(l.p2);
  }
}

void drawAnimatedTris() {
  for(AnimatedTriangle tri : animatedTris.values()) {
    tri.update(frameLength);
    tri.draw();
  }
}

boolean tryExpandingP(PVector p) {
  boolean somethingAdded = tryAddingP(p);
  
  ArrayList<Triangle> tris = vertexToTris.get(p);
  for(Triangle tri : tris) {
    if(!tryExpandingP(p, tri)) {
      AnimatedLine l1 = animatedLines.get(new Edge(tri.p1, tri.p2));
      AnimatedLine l2 = animatedLines.get(new Edge(tri.p2, tri.p3));
      AnimatedLine l3 = animatedLines.get(new Edge(tri.p3, tri.p1));
      
      if(l1 != null && l2 != null && l3 != null && 
          l1.isAnimationComplete() && l2.isAnimationComplete() && l3.isAnimationComplete()) {
        somethingAdded |= tryAddingTri(tri);
      }
    }
  }
  
  return somethingAdded;
}

boolean tryExpandingP(PVector p, Triangle tri) {
  boolean r = false;
  if(tri.p1.equals(p)) {
    r |= tryAddLine(tri.p1, tri.p2);
    r |= tryAddLine(tri.p1, tri.p3);
  } else if(tri.p2.equals(p)) {
    r |= tryAddLine(tri.p2, tri.p1);
    r |= tryAddLine(tri.p2, tri.p3);
  } else {
    r |= tryAddLine(tri.p3, tri.p1);
    r |= tryAddLine(tri.p3, tri.p2);
  }
  
  return r;
}

boolean tryAddLine(PVector p1, PVector p2) {
  Edge e = new Edge(p1, p2);
  AnimatedLine l = animatedLines.get(e);
  if(l != null)
    return false;
    
  l = new AnimatedLine(p1, p2, 1f);
  l.startAnimation();
  animatedLines.put(e, l);
  
  return true;
}

boolean tryAddingTri(Triangle tri) {
  AnimatedTriangle t = animatedTris.get(tri);
  if(t != null)
    return false;
    
  TriangleStats triStats = stats.triStats.get(tri);
  t = new AnimatedTriangle(tri, color(triStats.avgR, triStats.avgG, triStats.avgB));
  t.startAnimation();
  animatedTris.put(tri, t);
  
  return true;
}

boolean tryAddingP(PVector p) {
  if(animatedPoints.containsKey(p)) {
    return false;
  }
  
  AnimatedPoint newP = new AnimatedPoint(p, 5);
  newP.bounce();
  animatedPoints.put(newP.pos, newP);
  return true;
}

float worldToPixel(float worldComp) {
  return (worldComp - worldPad) * worldToPixel;
}

void worldToPixel(PVector in, PVector out) {
  out.x = (in.x - worldPad) * worldToPixel;
  out.y = (in.y - worldPad) * worldToPixel;
}

float pixelToWorld(float pixelComp) {
  return (pixelComp / worldToPixel) + worldPad;
}

float computeSD(float centerWorldX, float centerWorldY, float pixelDist) {
  float pixelX = worldToPixel(centerWorldX);
  float pixelY = worldToPixel(centerWorldY);
  
  int minX = floor(pixelX - pixelDist);
  int minY = floor(pixelY - pixelDist);
  int maxX = ceil(pixelX + pixelDist);
  int maxY = ceil(pixelY + pixelDist);
  
  // Compute averages and total area
  double rSum = 0;
  double gSum = 0;
  double bSum = 0;
  int totalPixels = 0;
  for(int x = minX; x <= maxX; x++) {
    int testX = max(0, min(img.width-1, x));
    for(int y = minY; y <= maxY; y++) {
      int testY = max(0, min(img.height-1, y));
      color argb = img.get(testX, testY);
      int r = (argb >> 16) & 0xFF;  // Faster way of getting red(argb)
      int g = (argb >> 8) & 0xFF;   // Faster way of getting green(argb)
      int b = argb & 0xFF;
      
      rSum += r;
      gSum += g;
      bSum += b;
      totalPixels++;
    }
  }
  
  if(totalPixels == 0) {
    return 0;
  }
  
  // Compute standard deviation
  float rAvg = (float)(rSum / totalPixels);
  float gAvg = (float)(gSum / totalPixels);
  float bAvg = (float)(bSum / totalPixels);
  
  double rSD = 0;
  double gSD = 0;
  double bSD = 0;
  for(int x = minX; x <= maxX; x++) {
    int testX = max(0, min(img.width-1, x));
    for(int y = minY; y <= maxY; y++) {
      int testY = max(0, min(img.height-1, y));
      
      color argb = img.get(testX, testY);
      int r = (argb >> 16) & 0xFF;
      int g = (argb >> 8) & 0xFF; 
      int b = argb & 0xFF;
      
      rSD += sq(r - rAvg);
      gSD += sq(g - gAvg);
      bSD += sq(b - bAvg);
    }
  }
  
  rSD = sqrt((float)(rSD / totalPixels));
  gSD = sqrt((float)(gSD / totalPixels));
  bSD = sqrt((float)(bSD / totalPixels));
  
  return (float)(rSD + gSD + bSD) / 3f;
}
