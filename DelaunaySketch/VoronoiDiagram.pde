class VoronoiDiagram {
  ArrayList<ArrayList<VTriangle>> convertDelaunay(ArrayList<Triangle> tris) {
    ArrayList<VTriangle> convertedTris = new ArrayList<VTriangle>();
    for(Triangle tri : tris) {
      VTriangle newTri = new VTriangle(tri.p1.copy(), tri.p2.copy(), tri.p3.copy());
      convertedTris.add(newTri);
    }
    
    return convertDelaunayHelper(convertedTris);
  }
  
  ArrayList<ArrayList<VTriangle>> convertDelaunayHelper(ArrayList<VTriangle> tris) {
    
    ArrayList<ArrayList<VTriangle>> polys = new ArrayList<ArrayList<VTriangle>>();
    
    // Make all triangles clockwise so we can walk them later with this assumption
    for(VTriangle tri : tris) {
      tri.makeClockwise();
    }
    
    // Find all adjacent triangles 
    HashMap<Edge, VTriangle> triWithEdge = new HashMap<Edge, VTriangle>();
    for(VTriangle tri : tris) {
      Edge e1 = new Edge(tri.p1, tri.p2);
      Edge e2 = new Edge(tri.p2, tri.p3);
      Edge e3 = new Edge(tri.p3, tri.p1);
      
      if(triWithEdge.containsKey(e1)) {
        VTriangle tri2 = triWithEdge.get(e1);
        tri.addEdgeNeighbor(tri2, 0);
        tri2.addEdgeNeighbor(tri, e1);
      } else {
        triWithEdge.put(e1, tri);
      }
      
      if(triWithEdge.containsKey(e2)) {
        VTriangle tri2 = triWithEdge.get(e2);
        tri.addEdgeNeighbor(tri2, 1);
        tri2.addEdgeNeighbor(tri, e2);
      } else {
        triWithEdge.put(e2, tri);
      }
      
      if(triWithEdge.containsKey(e3)) {
        VTriangle tri2 = triWithEdge.get(e3);
        tri.addEdgeNeighbor(tri2, 2);
        tri2.addEdgeNeighbor(tri, e3);
      } else {
        triWithEdge.put(e3, tri);
      }
    }
    
    for(VTriangle tri : tris) {
      // Create a polygon by walking adjacent edges
      // Walk the ed
      ArrayList<VTriangle> poly1 = createVoronoiPoly(tri, 0);
      ArrayList<VTriangle> poly2 = createVoronoiPoly(tri, 1);
      ArrayList<VTriangle> poly3 = createVoronoiPoly(tri, 2);
      if(poly1 != null) polys.add(poly1);
      if(poly2 != null) polys.add(poly2);
      if(poly3 != null) polys.add(poly3);
      // TODO Add these polys to a list
      // TODO make sure you're not adding duplicate polys (we're definitely generating lots of duplicates with this method)
      
      println(tri.getDebugString());
    }
    
    return polys;
  }
  
  ArrayList<VTriangle> createVoronoiPoly(VTriangle start, int edgeIndex) {
    ArrayList<VTriangle> poly = new ArrayList<VTriangle>();
    poly.add(start);
    VTriangle prev = start;
    VTriangle next = start.edgeNeighbors[edgeIndex];
    while(true) {
      if(next == null) {
        // TODO use the edge from prev to determine where it would hit the boundary
        // 1. Create a function on triangle that returns the 2 verts given the "edgeIndex"
        // 2. Compute the edge's normal
        // 3. Cast a ray from the circumcenter along the normal, and find a boundary intersection
        // 4. Refactor the output to take a list of points, or be able to take either a tri or a boundary vertex
        return null;  // TODO for now return null, but this is the case where we need to handle boundaries
      }
      
      if(next == start)
        return poly;
      
      poly.add(next);
      int prevIndex;
      for(prevIndex = 0; prevIndex < 3; prevIndex++) {
        if(next.edgeNeighbors[prevIndex] == prev) {
          break;
        }
      }
      int nextNextIndex = (prevIndex + 1) % 3;  // Move to the next clockwise neighbor of the "next" tri
      prev = next;
      next = next.edgeNeighbors[nextNextIndex];
    }
    
  }
  
  public void drawPoly(ArrayList<VTriangle> poly) {
    stroke(255, 0, 0);
    strokeWeight(.25f);
    //noFill();
    fill(random(0,255),random(0,255),random(0,255));
    beginShape();
    for(VTriangle tri : poly) {
      PVector c = tri.circumCenter.center;
      vertex(c.x, c.y);
    }
    endShape(CLOSE);
  }
}

class VTriangle {
  PVector p1;
  PVector p2;
  PVector p3;
  Circle circumCenter;
  color c;
  
  VTriangle[] edgeNeighbors = new VTriangle[3];
  
  VTriangle(PVector p1, PVector p2, PVector p3) {
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
  
  void addEdgeNeighbor(VTriangle other, int index) {
    edgeNeighbors[index] = other;
  }
  
  void addEdgeNeighbor(VTriangle other, Edge e) {
    if(e.equals(new Edge(p1, p2))) {
      edgeNeighbors[0] = other;
    } else if(e.equals(new Edge(p2, p3))) {
      edgeNeighbors[1] = other;
    } else if(e.equals(new Edge(p3, p1))) {
      edgeNeighbors[2] = other;
    } else {
      println("FAILED TO FIND EDGE NEIGHBOR: " + this + ", "+ other);
    }
  }
  
  boolean isClockwise() {
    float d = (p2.x - p1.x) * (p3.y - p1.y) - (p3.x - p1.x) * (p2.y - p1.y);  // compute determinant
    return d < 0;
  }
  
  void makeClockwise() {
    if(isClockwise())
      return;
      
    PVector tmp = p2;
    p2 = p1;
    p1 = tmp;
  }
  
  boolean circumCircleContains(PVector other) {
    return other.dist(circumCenter.center) <= circumCenter.radius;
  }
  
  String getDebugString() {
    String s = p1 + ", " + p2 + ", " + p3;
    s += "\n-- e[0] = " + edgeNeighbors[0];
    s += "\n-- e[1] = " + edgeNeighbors[1];
    s += "\n-- e[2] = " + edgeNeighbors[2];
    return s;
  }
  
  String toString() {
    return p1 + ", " + p2 + ", " + p3;
  }
}
