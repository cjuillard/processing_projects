
BoneChain lockedChain = new BoneChain(320, 200, 50, 20);

ArrayList<BoneChain> chains = new ArrayList<BoneChain>();
ArrayList<Boid> boids = new ArrayList<Boid>();
float minBoidSpeed = 1;
float maxBoidSpeed = 2;
PVector base;

void setup() {
   size(600, 400);
   
   base = new PVector(width / 2f, height);
   
   for(int i = 0; i < 20; i++) {
     chains.add(new BoneChain(random(width), random(height), 10, 10));
     
     PVector vel = PVector.random2D().mult(random(minBoidSpeed, maxBoidSpeed));
     boids.add(new Boid(random(width), random(height), vel.x, vel.y));
   }
}

void draw() {
  background(51);
  
  for(int i = 0; i < chains.size(); i++) {
    BoneChain chain = chains.get(i);
    Boid boid = boids.get(i);
    
    boid.update();
    chain.update(boid.pos.x, boid.pos.y);
    chain.draw();
  }
  
  lockedChain.update(mouseX, mouseY);
  
  ArrayList<Segment> bones = lockedChain.bones;
  bones.get(0).setA(base);
  for(int i = 1; i < bones.size(); i++) {
    bones.get(i).setA(bones.get(i-1).b);
  }
  lockedChain.draw();
}
