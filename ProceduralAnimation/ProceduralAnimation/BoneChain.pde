
class BoneChain {
  ArrayList<Segment> bones = new ArrayList<Segment>();
  
  BoneChain() {
    bones.add(new Segment(300, 200, 20, 0));
    for(int i = 0; i < 10; i++) {
      Segment next = new Segment(bones.get(i), 20, 0);
      bones.add(next);
    }
  }
  
  void update() {
    int numBones = bones.size();
    Segment last = bones.get(numBones - 1);
    last.follow(mouseX, mouseY);
    last.update();
    
    for(int i = numBones - 2; i >= 0; i--) {
      Segment parent = bones.get(i);
      Segment child = bones.get(i+1);
      parent.follow(child.a.x, child.a.y);
      parent.update();
    }
  }
  
  void draw() {
    for(int i = 0; i < bones.size(); i++) {
      strokeWeight(map(i, 0, bones.size() - 1, 4, 1));
      bones.get(i).show();
    }
  }
}
