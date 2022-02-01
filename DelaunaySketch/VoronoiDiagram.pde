class VoronoiDiagram {
  ArrayList<ArrayList<Triangle>> convertDelaunay(ArrayList<Triangle> tris) {
    
    ArrayList<ArrayList<Triangle>> polys = new ArrayList<ArrayList<Triangle>>();
    
    // Make all triangles clockwise so we can walk them later with this assumption
    for(Triangle tri : tris) {
      tri.makeClockwise();
    }
    
    // Find all adjacent triangles 
    HashMap<Edge, Triangle> triWithEdge = new HashMap<Edge, Triangle>();
    for(Triangle tri : tris) {
      Edge e1 = new Edge(tri.p1, tri.p2);
      Edge e2 = new Edge(tri.p2, tri.p3);
      Edge e3 = new Edge(tri.p3, tri.p1);
      
      if(triWithEdge.containsKey(e1)) {
        Triangle tri2 = triWithEdge.get(e1);
        tri.addEdgeNeighbor(tri2, 0);
        tri2.addEdgeNeighbor(tri, e1);
      } else {
        triWithEdge.put(e1, tri);
      }
      
      if(triWithEdge.containsKey(e2)) {
        Triangle tri2 = triWithEdge.get(e2);
        tri.addEdgeNeighbor(tri2, 1);
        tri2.addEdgeNeighbor(tri, e2);
      } else {
        triWithEdge.put(e2, tri);
      }
      
      if(triWithEdge.containsKey(e3)) {
        Triangle tri2 = triWithEdge.get(e3);
        tri.addEdgeNeighbor(tri2, 2);
        tri2.addEdgeNeighbor(tri, e3);
      } else {
        triWithEdge.put(e3, tri);
      }
    }
    
    for(Triangle tri : tris) {
      // Create a polygon by walking adjacent edges
      // Walk the ed
      ArrayList<Triangle> poly1 = createVoronoiPoly(tri, 0);
      ArrayList<Triangle> poly2 = createVoronoiPoly(tri, 1);
      ArrayList<Triangle> poly3 = createVoronoiPoly(tri, 2);
      if(poly1 != null) polys.add(poly1);
      if(poly2 != null) polys.add(poly2);
      if(poly3 != null) polys.add(poly3);
      // TODO Add these polys to a list
      // TODO make sure you're not adding duplicate polys (we're definitely generating lots of duplicates with this method)
      
      println(tri.getDebugString());
    }
    
    return polys;
  }
  
  ArrayList<Triangle> createVoronoiPoly(Triangle start, int edgeIndex) {
    ArrayList<Triangle> poly = new ArrayList<Triangle>();
    poly.add(start);
    Triangle prev = start;
    Triangle next = start.edgeNeighbors[edgeIndex];
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
}
