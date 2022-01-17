boolean useDiscreteDirections = false;
int numDirections = 10;

public class Particle {
   public PVector Pos = new PVector();
   public PVector Velocity = new PVector();
   public float size = 8;
   public float Drag = .99f;
   
   
   private PVector tmp = new PVector();
   public void update() {
     Velocity.mult(Drag);
     
     if(useDiscreteDirections) {
       float heading = Velocity.heading();
       float stepSize = (TWO_PI / numDirections);
       float remainder = heading % stepSize;
       heading = round(heading / stepSize) * stepSize;
       tmp.set(cos(heading), sin(heading)).mult(Velocity.mag());
       Pos.add(tmp); 
     } else
       Pos.add(Velocity); 
     if(Pos.x < 0)
       Pos.x = width;
     if(Pos.x > width)
       Pos.x = 0;
       
     if(Pos.y < 0)
       Pos.y = height;
     if(Pos.y > height)
       Pos.y = 0;
       
   }
   public void draw() {
     ellipse(Pos.x, Pos.y, size, size);
   }
}
