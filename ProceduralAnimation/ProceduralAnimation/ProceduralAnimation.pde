
BoneChain chain = new BoneChain();

void setup() {
   size(600, 400);
}

void draw() {
  background(51);
  
  chain.update();
  chain.draw();
}
