
ArrayList<BoneChain> chains = new ArrayList<BoneChain>();
ArrayList<Boid> boids = new ArrayList<Boid>();
ArrayList<PVector> bases = new ArrayList<PVector>();

float minBoidSpeed = 1;
float maxBoidSpeed = 2;

void setup() {
   size(600, 400);
   
   //base = new PVector(width / 2f, height);
   
   for(int i = 0; i < 20; i++) {
     chains.add(new BoneChain(random(width), random(height), 50, 10));
     
     PVector vel = PVector.random2D().mult(random(minBoidSpeed, maxBoidSpeed));
     boids.add(new Boid(random(width), random(height), vel.x, vel.y));
     
     bases.add(new PVector(random(width), random(height)));
   }
}

void draw() {
  background(51);
  
  for(int i = 0; i < chains.size(); i++) {
    BoneChain chain = chains.get(i);
    Boid boid = boids.get(i);
    
    boid.update();
    chain.update(boid.pos.x, boid.pos.y);
    
    PVector base = bases.get(i);
    ArrayList<Segment> bones = chain.bones;
    bones.get(0).setA(base);
    for(int j = 1; j < bones.size(); j++) {
      bones.get(j).setA(bones.get(j-1).b);
    }
  }
  
  //lockedChain.update(mouseX, mouseY);
  
  //ArrayList<Segment> bones = lockedChain.bones;
  //bones.get(0).setA(base);
  //for(int i = 1; i < bones.size(); i++) {
  //  bones.get(i).setA(bones.get(i-1).b);
  //}
  //lockedChain.draw();
  
  for(BoneChain chain : chains) {
    chain.draw();
  }
  
  for(Boid boid : boids) {
    boid.draw();
  }
  
}
