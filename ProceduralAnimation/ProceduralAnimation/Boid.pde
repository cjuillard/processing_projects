class Boid {
 PVector pos = new PVector();
 PVector vel = new PVector();
 Boid(float x, float y, float velX, float velY) {
  pos.set(x, y); 
  vel.set(velX, velY);
 }
 
 void update() {
   pos.add(vel);
   
   if(pos.x < 0) {
     pos.x = 0;
     vel.x *= -1;
   }
   
   if(pos.y < 0) {
     pos.y = 0;
     vel.y *= -1;
   }
   
   if(pos.x > width) {
     pos.x = width;
     vel.x *= -1;
   }
   
   if(pos.y > height) {
     pos.y = height;
     vel.y *= -1;
   }
 }
 
}
