PoissonDiscSampling sampling;
VariablePoissonDiscSampling variableSampling;
DelaunayTriangulation triangulation = new DelaunayTriangulation();
ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<Triangle> tris = new ArrayList<Triangle>();
ImageStats stats;
HashMap<PVector, ArrayList<Triangle>> vertexToTris = new HashMap<PVector, ArrayList<Triangle>>();

float worldToPixel = 1;
float scale = 1f;
float worldPad = 50;
float worldWidth;
float worldHeight;

PImage img;

Triangle testTri;

void setup() {
  // Size should be set according to image's size - calculations make this assumption
  //size(640, 640);
  //size(2048, 1375);  // 1.jpg
  //size(2048, 1536);  // 2.jpg
  //size(2048, 1360);  // 3.jpg
  size(512, 512);  // test1.png + test3.jpg
  //size(1024, 1024);  // test_large.png
  stroke(255);
  noFill();
  
  //img = loadImage("../Loops2/Loop2/test.jpg");
  img = loadImage("test.png");
  //img = loadImage("test_large.png");
  //img = loadImage("test2.jpg");
  //img = loadImage("test3.jpg");
  //img = loadImage("sample_images/1.jpg");
  //img = loadImage("sample_images/2.jpg");
  //img = loadImage("sample_images/3.jpg");
  
  randomSeed(0);
  //sampling = new PoissonDiscSampling(width * scale, height * scale, 10);
  worldWidth = width * scale + 2 * worldPad;
  worldHeight = height * scale + 2 * worldPad;
  worldToPixel = 1;
  
  sampling = new PoissonDiscSampling(worldWidth, worldHeight, 15);
  sampling.genPoints(points);
  
  final float minRadius = 4;
  final float maxRadius = 25;
  final float sdDist = 4;
  RadiusProvider radiusProvider = new RadiusProvider() {
    private float minSDFound = Float.MAX_VALUE;
    private float maxSDFound = Float.MIN_VALUE;
    public float getRadius(float worldX, float worldY) {
      float sd = computeSD(worldX, worldY, sdDist);
      float minSD = 2;
      float maxSD = 70;
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
      //return minRadius + (maxRadius - minRadius) * x / width;  // more sparse the further right we go
      //return 10;
      
    }
  };
  variableSampling = new VariablePoissonDiscSampling(worldWidth, worldHeight, minRadius, maxRadius, radiusProvider);
  variableSampling.genPoints(points);
  
  for(int x = 0; x < width; x++) {
    for(int y = 0; y < height; y++) {
      //println(computeSD(x,y,20));
    }
  }
  
  //genTestPoints();
  genTriangulationAndStats();
}

void genTriangulationAndStats() {
  triangulation.bowyerWatson(points, tris);
  
  float pixelToWorld = sampling.worldWidth / img.width;
  stats = new ImageStats(img, tris, pixelToWorld);
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

float computeScore(ArrayList<Triangle> tris) {
  int totalNumPixels = 0;
  float currSD = 0;
  for(Triangle tri : tris) {
    TriangleStats stat = stats.getStat(tri);
    if(stat.imgPixelsInside == 0) {
      return 0;  // Force these to not be removed
      
      //int biasPixels = 10;
      //currSD = totalNumPixels == 0 ? stats.maxSD : lerp(currSD, stats.minSD, biasPixels / (float)totalNumPixels);
      //totalNumPixels += biasPixels;  // bias them towards getting removed
      //continue;
      
      //return Float.MAX_VALUE;
      
    }
    
    if(totalNumPixels == 0) {
      currSD = stat.avgSD;
      totalNumPixels += stat.imgPixelsInside;
    } else {
      totalNumPixels += stat.imgPixelsInside;
      currSD = lerp(currSD, stat.avgSD, stat.imgPixelsInside / (float)totalNumPixels);
    }
  }
  
  return currSD;
}

int getClosestPointIndexToMousePos() {
  PVector mousePos = new PVector(mouseX, mouseY);
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
  
  //Collections.sort(points, new Comparator<PVector>(){
  //  @Override
  //  public int compare(PVector o1, PVector o2) {
  //    ArrayList<Triangle> tris1 = vertexToTris.get(o1);
  //    ArrayList<Triangle> tris2 = vertexToTris.get(o2);
      
  //    float s1 = computeScore(tris1);
  //    float s2 = computeScore(tris2);
  //    float delta = s1 - s2;
  //    if(delta == 0)
  //      return 0;
  //    if(delta < 0) 
  //      return 1;
      
  //    return -1;
  //  }
  //});
  
  //for(int i = points.size() - 1, n = points.size() - floor(.1f * points.size()); i >= n; i--) {
  //  ArrayList<Triangle> tris1 = vertexToTris.get(points.get(i));
  //  //println(computeScore(tris1));
  //  points.remove(i);
  //}
  
  //int minPosIndx = getClosestPointIndexToMousePos();

  //if(minPosIndx != -1) {
  //  points.remove(minPosIndx);
  //}
  
  //genTriangulationAndStats();
  
  println("computeSD(..)=" + computeSD(mouseX, mouseY, 10));
  
  //save("test.png");
  
  drawTris = !drawTris;
}

float clamp01(float val) {
  return max(0, min(1, val));
}

boolean drawTris = true;
void draw() {
  //background(0);
  image(img, 0, 0);
  
  //float offsetX = (width - sampling.worldWidth) * 0.5f;
  //float offsetY = (height - sampling.worldHeight) * 0.5f;
  pushMatrix();
  //translate(offsetX, offsetY);
  noFill();
  //drawPoints();
  
  if(drawTris)
    drawTris();
  
  int posIndex = getClosestPointIndexToMousePos();
  if(posIndex != -1) {
    PVector closest = points.get(posIndex);
    fill(255,0,0);
    circle(closest.x, closest.y, 3);
  }
  
  popMatrix();
}

void drawTris() {
  strokeWeight(2);
  
  PVector tmp1 = new PVector();
  PVector tmp2 = new PVector();
  PVector tmp3 = new PVector();
  for(Triangle tri : tris) {
    
    //stroke(255);
    strokeWeight(.1f);
    //noStroke();
    
    worldToPixel(tri.p1, tmp1);
    worldToPixel(tri.p2, tmp2);
    worldToPixel(tri.p3, tmp3);
    
    float centerWorldX = (tri.p1.x + tri.p2.x + tri.p3.x) / 3f;
    float centerWorldY = (tri.p1.y + tri.p2.y + tri.p3.y) / 3f;
    int pixelX = round(worldToPixel(centerWorldX));
    int pixelY = round(worldToPixel(centerWorldY));
    
    color col = img.get(pixelX, pixelY);
    fill(col);
    
    //stroke(col);
    stroke(255);
    TriangleStats triStats = stats.triStats.get(tri);
    fill(triStats.avgR, triStats.avgG, triStats.avgB);
    
    float sdIntensity = clamp01((triStats.avgSD - stats.minSD) / (stats.maxSD - stats.minSD)) * 255;
    //fill(sdIntensity, sdIntensity, sdIntensity);
    float normalizedScore = (triStats.avgSD - stats.minSD) / (stats.maxSD - stats.minSD);
    //fill(normalizedScore * 255);
    
    //fill(tri.c);
    triangle(tmp1.x, tmp1.y, tmp2.x, tmp2.y, tmp3.x, tmp3.y);
    
    Circle c = tri.circumCenter;
    //circle(c.center.x, c.center.y, c.radius * 2);
  }
}

void drawPoints() {
  for(PVector p : points) {
    strokeWeight(4);
    stroke(255);
    point(p.x, p.y);
  }
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
    int testX = max(0, min(img.width, x));
    for(int y = minY; y <= maxY; y++) {
      int testY = max(0, min(img.height, y));
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
    int testX = max(0, min(img.width, x));
    for(int y = minY; y <= maxY; y++) {
      int testY = max(0, min(img.height, y));
      
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
