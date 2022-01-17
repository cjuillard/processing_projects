public interface IDrawable {
 void draw(); 
}

public class DotSurface implements IDrawable {
  PVector light = new PVector(0.25f, 0.25f, 1f);
  public DotSurface() {
     light.normalize();
  }
  
  public void draw() {
    float t = frameCount/(float)numFrames;
  
    stroke(0);
    
    pushMatrix();
    //rotateZ(PI/2f);
    //camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
    //camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
    rotateX(PI/6f);
  
    fill(255);
    PVector p0 = new PVector();
    PVector p1 = new PVector();
    PVector p2 = new PVector();
    PVector p3 = new PVector();
    strokeWeight(1);
    beginShape(QUADS);
    for(int i=0;i<subdivisions;i++)
    {
      for(int j=0;j<subdivisions;j++)
      {
        this.getWavyPos(i,j,t,p0);
        this.getWavyPos(i,j+1,t,p1);
        this.getWavyPos(i+1,j+1,t,p2);
        this.getWavyPos(i+1,j,t,p3);
        
        vertex(p0.x, p0.y, p0.z);
        vertex(p1.x, p1.y, p1.z);
        vertex(p2.x, p2.y, p2.z);
        vertex(p3.x, p3.y, p3.z);
      }
    }
    endShape();
    
    PVector n0 = new PVector();
    strokeWeight(5);
    
    float noiseScl = .3f;
    for(int i=0;i<subdivisions;i++)
    {
      for(int j=0;j<subdivisions;j++)
      {
        //if(noise(i*noiseScl,j*noiseScl) < .5f)
        //  continue;
          
        //this.getWavyPos(i,j,t,p0);
        //this.getWavyPos(i,j+1,t,p1);
        //this.getWavyPos(i+1,j+1,t,p2);
        //this.getWavyPos(i+1,j,t,p3);
        
        //vertex((p0.x + p2.x) * 0.5f, (p0.y + p2.y) * 0.5f, (p0.z + p2.z) * .5f);
        
        getNormalAndPos(i+0.5f, j+0.5f, t, p0, n0);
        n0.normalize();
        n0.mult(-1);
        float a = n0.dot(light);
        //println(n0 + " - " + light + " - " + a);
        if(a > 0) {
          strokeWeight(10 * a);
          beginShape(POINTS);
        
          vertex(p0.x, p0.y, p0.z);
          
          endShape();
        }
      }
    }
    
    popMatrix();
  }
  
  PVector tmpDelta1 = new PVector();
  PVector tmpDelta2 = new PVector();
  PVector tmpP1 = new PVector();
  PVector tmpP2 = new PVector();
  void getNormalAndPos(float i, float j, float t, PVector outPos, PVector outNormal) {
    float off = .01f;
    getWavyPos(i, j, t, outPos);
    getWavyPos(i, j + off, t, tmpP1);
    getWavyPos(i + off, j, t, tmpP2);
    
    tmpDelta1.set(tmpP1).sub(outPos);
    tmpDelta2.set(tmpP2).sub(outPos);
    tmpDelta1.cross(tmpDelta2, outNormal);
  }
  
  void getWavyPos(float i, float j, float t, PVector output) {
    float x = map(i,0,subdivisions,0,width);
    float y = map(j,0,subdivisions,0,height);
        
    float tOffset = offsetWavy(x,y);
    float offsetT = t-tOffset;
    
    //float zOffset = map(sin(TWO_PI * offsetT) + cos(TWO_PI * offsetT * 2) * .23f + sin(TWO_PI * offsetT * 3) * .1f,-1,1,1,50);
    float zOffset = map(sin(TWO_PI * offsetT),-1,1,1,50);
    
    output.set(x,y,zOffset);
  }
}
