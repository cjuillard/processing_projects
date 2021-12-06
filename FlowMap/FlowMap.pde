int scl = 10;
int rows = width / scl;
int cols = height / scl;
PVector[][] flowField = new PVector[rows][cols];

void setup() {
  size(1024, 768);
  for(int x = 0; x < cols; x++){
     for(int y = 0; y < rows; y++) {
       flowField[x][y] = PVector.random2D();
     }
  }
}

void draw() {
  if (mousePressed) {
    fill(0);
  } else {
    fill(255);
  }
  ellipse(mouseX, mouseY, 80, 80);
}
