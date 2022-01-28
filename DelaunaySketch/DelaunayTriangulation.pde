// https://en.wikipedia.org/wiki/Bowyer%E2%80%93Watson_algorithm
//function BowyerWatson (pointList)
//   // pointList is a set of coordinates defining the points to be triangulated
//   triangulation := empty triangle mesh data structure
//   add super-triangle to triangulation // must be large enough to completely contain all the points in pointList
//   for each point in pointList do // add all the points one at a time to the triangulation
//      badTriangles := empty set
//      for each triangle in triangulation do // first find all the triangles that are no longer valid due to the insertion
//         if point is inside circumcircle of triangle
//            add triangle to badTriangles
//      polygon := empty set
//      for each triangle in badTriangles do // find the boundary of the polygonal hole
//         for each edge in triangle do
//            if edge is not shared by any other triangles in badTriangles
//               add edge to polygon
//      for each triangle in badTriangles do // remove them from the data structure
//         remove triangle from triangulation
//      for each edge in polygon do // re-triangulate the polygonal hole
//         newTri := form a triangle from edge to point
//         add newTri to triangulation
//   for each triangle in triangulation // done inserting points, now clean up
//      if triangle contains a vertex from original super-triangle
//         remove triangle from triangulation
//   return triangulation

class DelaunayTriangulation {
  void bowyerWatson(ArrayList<PVector> points, ArrayList<Triangle> outputTriangles) {
    outputTriangles.clear();
    outputTriangles.add(createSuperTriangle(points));
    
    ArrayList<Triangle> badTris = new ArrayList<Triangle>();
    for(PVector p : points) {
      badTris.clear();
      
      for(Triangle tri : outputTriangles) {
        if(tri.circumCircleContains(p)) {
          
        }
      }
    }
    //add super-triangle to triangulation // must be large enough to completely contain all the points in pointList
//   for each point in pointList do // add all the points one at a time to the triangulation
//      badTriangles := empty set
//      for each triangle in triangulation do // first find all the triangles that are no longer valid due to the insertion
//         if point is inside circumcircle of triangle
//            add triangle to badTriangles
//      polygon := empty set
//      for each triangle in badTriangles do // find the boundary of the polygonal hole
//         for each edge in triangle do
//            if edge is not shared by any other triangles in badTriangles
//               add edge to polygon
//      for each triangle in badTriangles do // remove them from the data structure
//         remove triangle from triangulation
//      for each edge in polygon do // re-triangulate the polygonal hole
//         newTri := form a triangle from edge to point
//         add newTri to triangulation
//   for each triangle in triangulation // done inserting points, now clean up
//      if triangle contains a vertex from original super-triangle
//         remove triangle from triangulation
//   return triangulation
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
  
  Triangle(PVector p1, PVector p2, PVector p3) {
    this.p1 = p1;
    this.p2 = p2;
    this.p3 = p3;
    
    // https://en.wikipedia.org/wiki/Circumscribed_circle#Triangles - catesian coordinates equation
    float d = 2 * (p1.x * (p2.y - p3.y) + p2.x * (p3.y - p1.y) + p3.x * (p1.y - p2.y));
    
    float sqP1 = sq(p1.x) + sq(p1.y);
    float sqP2 = sq(p2.x) + sq(p2.y);
    float sqP3 = sq(p3.x) + sq(p3.y);
    float x = (sqP1 * (p2.y - p3.y) + sqP2 * (p3.y - p1.y) + sqP3 * (p1.y - p2.y)) / d;
    float y = (sqP1 * (p3.x - p2.x) + sqP2 * (p1.x - p3.x) + sqP3 * (p2.x - p1.x)) / d;
    PVector center = new PVector(x,y);
    circumCenter = new Circle(center, center.dist(p1)); 
  }
  
  boolean circumCircleContains(PVector other) {
    return true;
  }
}
