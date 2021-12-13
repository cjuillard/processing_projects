public class GIFSaver {
  public int currFrame = 0; 
  private String prefix;
  
  public GIFSaver(String prefix) {
    this.prefix = prefix;
  }
  
  public void saveFrame() {
    save(prefix + currFrame + ".png");
    currFrame++;
  }
}
