import java.util.*;

class DelaunayTriangulation {
  private HashSet<PVector> superTriPoints = new HashSet<PVector>();
  
  // https://en.wikipedia.org/wiki/Bowyer%E2%80%93Watson_algorithm
  void bowyerWatson(ArrayList<PVector> points, ArrayList<Triangle> outputTriangles) {
    outputTriangles.clear();
    outputTriangles.add(createSuperTriangle(points));
    
    superTriPoints.clear();
    for(Triangle tri : outputTriangles) {
      superTriPoints.add(tri.p1);
      superTriPoints.add(tri.p2);
      superTriPoints.add(tri.p3);
    }
    
    HashSet<Edge> polygon = new HashSet<Edge>();
    HashSet<Edge> sharedEdges = new HashSet<Edge>();
    ArrayList<Triangle> badTris = new ArrayList<Triangle>();
    for(int i = 0; i < points.size(); i++) {
    //for(PVector p : points) {
      PVector p = points.get(i);
      badTris.clear();
      
      for(Triangle tri : outputTriangles) {
        if(tri.circumCircleContains(p)) {
          badTris.add(tri);
        }
      }
      
      polygon.clear();
      sharedEdges.clear();
      for(Triangle tri : badTris) {
        Edge e1 = new Edge(tri.p1, tri.p2);
        Edge e2 = new Edge(tri.p2, tri.p3);
        Edge e3 = new Edge(tri.p3, tri.p1);
        
        // Add the edges to the polygon - but if those edges already exist in the polygon add them to the sharedEdges set to get removed
        if(!polygon.add(e1)) sharedEdges.add(e1);
        if(!polygon.add(e2)) sharedEdges.add(e2);
        if(!polygon.add(e3)) sharedEdges.add(e3);
        
        outputTriangles.remove(tri);
      }
      
      for(Edge e : sharedEdges) {
        polygon.remove(e);
      }
      
      for(Edge e : polygon) {
        outputTriangles.add(new Triangle(p, e.p1, e.p2));
      }
    }
    
    for(int i = outputTriangles.size() - 1; i >= 0; i--) {
      Triangle tri = outputTriangles.get(i);
      if(superTriPoints.contains(tri.p1) ||
          superTriPoints.contains(tri.p2) ||
          superTriPoints.contains(tri.p3)) {
        outputTriangles.remove(i);
      }
    }
  }  
  
  Triangle createSuperTriangle(ArrayList<PVector> points) {
    float minX = Float.MAX_VALUE;
    float minY = Float.MAX_VALUE;
    float maxX = Float.MIN_VALUE;
    float maxY = Float.MIN_VALUE;
    
    for(PVector point : points) {
      minX = min(minX, point.x);
      minY = min(minY, point.y);
      maxX = max(maxX, point.x);
      maxY = max(maxY, point.y);
    }
    
    float boundW = maxX - minX;
    float boundH = maxY - minY;
    float fudge = boundH * .2f;  // Without this fudge the edges of [p1,p2] and [p2,p3] would touch the upper left and upper right corners of the bounds
    Triangle superTriangle = new Triangle(
      new PVector(minX - boundW, minY - boundH),
      new PVector(minX + boundW * 0.5f, maxY + boundH + fudge),
      new PVector(maxX + boundW, minY - boundH)); 
    
    return superTriangle;
  }
}

class Edge {
 PVector p1;
 PVector p2;
 
 Edge(PVector p1, PVector p2) {
   // Set these values in a sorted way so the hashcode doesn't have to worry about sorting them to get a consistent hashcode
   if(p1.x < p2.x) {
     set(p1,p2);
     return;
   } else if(p1.x > p2.x) {
     set(p2,p1);
     return;
   }
     
   if(p1.y < p2.y) {
     set(p1,p2);
   }
   else if(p1.y > p2.y) { 
     set(p2,p1);
   }
   else
     set(p1,p2);
 }
 
 private void set(PVector p1, PVector p2) {
   this.p1 = p1;
   this.p2 = p2;
 }
  
 public int hashCode() {
   return Objects.hash(p1, p2);
  }
  
  public boolean equals(Object o){
    if(o == null || !(o instanceof Edge))
      return false;
    Edge oEdge = (Edge)o;
    if(p1.equals(oEdge.p1) && p2.equals(oEdge.p2))
      return true;
    if(p1.equals(oEdge.p2) && p2.equals(oEdge.p1))
      return true;
      
    return false;
  }
}
class Circle {
 PVector center;
 float radius;
 
 Circle(PVector center, float radius) {
   this.center = center;
   this.radius = radius;
 }
}

class Triangle {
  PVector p1;
  PVector p2;
  PVector p3;
  Circle circumCenter;
  color c;
  
  Triangle(PVector p1, PVector p2, PVector p3) {
    this.p1 = p1;
    this.p2 = p2;
    this.p3 = p3;
    c = color(random(255), random(255), random(255));
    
    // https://en.wikipedia.org/wiki/Circumscribed_circle#Triangles - cartesian coordinates equation
    float d = 2 * (p1.x * (p2.y - p3.y) + p2.x * (p3.y - p1.y) + p3.x * (p1.y - p2.y));
    
    float sqP1 = sq(p1.x) + sq(p1.y);
    float sqP2 = sq(p2.x) + sq(p2.y);
    float sqP3 = sq(p3.x) + sq(p3.y);
    float x = (sqP1 * (p2.y - p3.y) + sqP2 * (p3.y - p1.y) + sqP3 * (p1.y - p2.y)) / d;
    float y = (sqP1 * (p3.x - p2.x) + sqP2 * (p1.x - p3.x) + sqP3 * (p2.x - p1.x)) / d;
    PVector center = new PVector(x,y);
    circumCenter = new Circle(center, center.dist(p1)); 
  }
  
  boolean isClockwise() {
    float d = computeDeterminant();
    return d < 0;
  }
  
  float computeDeterminant() {
    return (p2.x - p1.x) * (p3.y - p1.y) - (p3.x - p1.x) * (p2.y - p1.y);
  }
  
  float getArea() {
    return 0.5f * computeDeterminant();
  }
  
  void makeClockwise() {
    if(isClockwise())
      return;
      
    PVector tmp = p2;
    p2 = p1;
    p1 = tmp;
  }
  
  // Returns whether this point is contained within the triangle
  boolean isInside(PVector p) {
    return edgeFunction(p1, p2, p) && edgeFunction(p2, p3, p) && edgeFunction(p3, p1, p);
  }
  
  boolean edgeFunction(PVector a, PVector b, PVector p) { 
    return ((p.x - a.x) * (b.y - a.y) - (p.y - a.y) * (b.x - a.x) >= 0); 
  } 
  
  boolean circumCircleContains(PVector other) {
    return other.dist(circumCenter.center) <= circumCenter.radius;
  }
  
  String toString() {
    return p1 + ", " + p2 + ", " + p3;
  }
}
