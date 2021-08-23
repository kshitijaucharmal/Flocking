
Boid[] boids;
int n_boids = 50;

PGraphics pg;

void setup(){
  size(600, 600);
  pixelDensity(1);
  pg = createGraphics(width, height);
  frameRate(60);
  boids = new Boid[n_boids];
  for(int i = 0; i < n_boids; i++){
    boids[i] = new Boid(random(width), random(height));
  }
}

void draw(){
  background(0);
  pg.beginDraw();
  pg.background(51);
  
  pg.fill(255, 0, 0);
  
  for(Boid boid : boids){
    boid.edges();
    boid.flock(boids);
    boid.update();
    boid.render();
  }
  pg.endDraw();
  image(pg, 0, 0);
}
