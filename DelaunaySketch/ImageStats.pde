class ImageStats {
  HashMap<Triangle, TriangleStats> triStats = new HashMap<Triangle, TriangleStats>();
  PImage img;
  float pixelToWorld;
  float worldToPixel;
  float minSD;
  float maxSD;
  
  ImageStats(PImage img, ArrayList<Triangle> triangles, float pixelToWorld) {
    this.img = img;
    this.pixelToWorld = pixelToWorld;
    this.worldToPixel = 1f / pixelToWorld;
  
    minSD = Float.MAX_VALUE;
    maxSD = Float.MIN_VALUE;
    for(Triangle tri : triangles) {
      tri.makeClockwise();
      TriangleStats stats = computeTriStats(tri);
      triStats.put(tri, stats);
      
      minSD = min(minSD, stats.avgSD);
      maxSD = max(maxSD, stats.avgSD);
    }
  }
  
  TriangleStats getStat(Triangle tri) {
    return triStats.get(tri);
  }
  
  TriangleStats computeTriStats(Triangle tri) {
    int minX = floor(min(tri.p1.x, min(tri.p2.x, tri.p3.x)) * worldToPixel);
    int minY = floor(min(tri.p1.y, min(tri.p2.y, tri.p3.y)) * worldToPixel);
    int maxX = ceil(max(tri.p1.x, max(tri.p2.x, tri.p3.x)) * worldToPixel);
    int maxY = ceil(max(tri.p1.y, max(tri.p2.y, tri.p3.y)) * worldToPixel);
    
    TriangleStats stats = new TriangleStats();
    stats.t = tri;
    
    PVector testPos = new PVector();
    
    // Compute averages and total area
    double rSum = 0;
    double gSum = 0;
    double bSum = 0;
    int totalPixels = 0;
    for(int x = minX; x <= maxX; x++) {
      for(int y = minY; y <= maxY; y++) {
        
        testPos.set(x * pixelToWorld, y * pixelToWorld);
        if(tri.isInside(testPos)) {
          color argb = img.get(x, y);
          int r = (argb >> 16) & 0xFF;  // Faster way of getting red(argb)
          int g = (argb >> 8) & 0xFF;   // Faster way of getting green(argb)
          int b = argb & 0xFF;
          
          rSum += r;
          gSum += g;
          bSum += b;
          totalPixels++;
        }
      }
    }
    
    if(totalPixels == 0) {
      return stats;
    }
    
    // Compute standard deviation
    float rAvg = (float)(rSum / totalPixels);
    float gAvg = (float)(gSum / totalPixels);
    float bAvg = (float)(bSum / totalPixels);
    
    double rSD = 0;
    double gSD = 0;
    double bSD = 0;
    for(int x = minX; x <= maxX; x++) {
      for(int y = minY; y <= maxY; y++) {
        
        testPos.set(x * pixelToWorld, y * pixelToWorld);
        if(tri.isInside(testPos)) {
          color argb = img.get(x, y);
          int r = (argb >> 16) & 0xFF;
          int g = (argb >> 8) & 0xFF; 
          int b = argb & 0xFF;
          
          rSD += sq(r - rAvg);
          gSD += sq(g - gAvg);
          bSD += sq(b - bAvg);
        }
      }
    }
    
    rSD = sqrt((float)(rSD / totalPixels));
    gSD = sqrt((float)(gSD / totalPixels));
    bSD = sqrt((float)(bSD / totalPixels));
    
    stats.imgPixelsInside = totalPixels;
    stats.rSD = (float)rSD;
    stats.gSD = (float)gSD;
    stats.bSD = (float)bSD;
    
    stats.avgSD = (stats.rSD + stats.gSD + stats.bSD) / 3f;
    return stats;
  }
}

class TriangleStats {
  Triangle t;
  int imgPixelsInside;
  
  // Standard deviation on each channel
  float rSD;
  float gSD;
  float bSD;

  float avgSD;
}
