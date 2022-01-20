
BoneChain chain = new BoneChain();

PVector base;

void setup() {
   size(600, 400);
   
   base = new PVector(width / 2f, height);
}

void draw() {
  background(51);
  
  chain.update();
  
  ArrayList<Segment> bones = chain.bones;
  bones.get(0).setA(base);
  for(int i = 1; i < bones.size(); i++) {
    bones.get(i).setA(bones.get(i-1).b);
  }
  chain.draw();
}
