class PoissonDiscSampling {
  float worldWidth, worldHeight;
  float radius;
  float samples = 30;
  float w;
  PVector[] grid;
  int cols;
  int rows;
  
  ArrayList<PVector> active = new ArrayList<PVector>();
  
  PoissonDiscSampling(float worldWidth, float worldHeight, float radius) {
    this.worldWidth = worldWidth;
    this.worldHeight = worldHeight;
    this.radius = radius;
    w = radius / sqrt(2);
    cols = floor(worldWidth / w);
    rows = floor(worldHeight / w);
    grid = new PVector[cols * rows];
  }
  
  public void setSampleCount(int numSamples) {
    this.samples = numSamples;
  }
  
  public void genPoints(ArrayList<PVector> output) {
    output.clear();
    
    // Insert first position
    float x = random(worldWidth);
    float y = random(worldHeight);
    int i = floor(x / w);
    int j = floor(y / w);
    PVector pos = new PVector(x,y);
    grid[i + j * cols] = pos;
    active.add(pos);
    
    while(active.size() > 0) {
      expandStep();
    }
    
    for(PVector p : grid) {
      if(p != null)
        output.add(p);
    }
    
    for(int indx = 0, n = grid.length; indx < n; indx++) {
      grid[indx] = null;
    }
  }
  
  private void expandStep() {
    int index = floor(random(active.size()));
    PVector curr = active.get(index);
    
    boolean hasFoundOneValid = false;
    for(int i = 0; i < samples; i++) {
      PVector sample = PVector.random2D();
      sample.setMag(random(radius, 2*radius));
      sample.add(curr);
      
      int col = floor(sample.x / w);
      int row = floor(sample.y / w);
      if(col < 0 || row < 0 || col >= cols || row >= rows)
        continue;
        
      boolean validSample = true;
      for(int rOff = -1; rOff <= 1; rOff++) {
       int currRow = row + rOff; 
       if(currRow < 0 || currRow >= rows)
         continue;
         
       for(int cOff = -1; cOff <= 1; cOff++) {
         int currCol = col + cOff;
         if(currCol < 0 || currCol >= cols)
           continue;
           
         PVector neighbor = grid[currCol + currRow * cols];
         if(neighbor == null)
           continue;
           
         float d = neighbor.dist(sample);
         if(d < radius) {
           validSample = false;
         }
       }
      }
      
      if(validSample) {
        hasFoundOneValid = true;
        int testIndex = col + row * cols;
        if(testIndex < 0 || testIndex >= grid.length)
          println("col/row=" + col + "," + row + " --> " + testIndex);
        grid[col + row * cols] = sample;
        active.add(sample);
      }
    }
    
    if(!hasFoundOneValid) {
      active.remove(index);
    }
  }
}
