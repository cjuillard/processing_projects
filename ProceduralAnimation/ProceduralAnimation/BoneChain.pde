
class BoneChain {
  ArrayList<Segment> bones = new ArrayList<Segment>();
  
  BoneChain(float x, float y, int numBones, float boneLen) {
    bones.add(new Segment(x, y, boneLen, 0));
    for(int i = 0; i < numBones - 1; i++) {
      Segment next = new Segment(bones.get(i), boneLen, 0);
      bones.add(next);
    }
  }
  
  void addBone(int len, float angle) {
    Segment next = new Segment(bones.get(bones.size() - 1), len, angle);
    bones.add(next);
  }
  
  void update(float followX, float followY) {
    int numBones = bones.size();
    Segment last = bones.get(numBones - 1);
    last.follow(followX, followY);
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
