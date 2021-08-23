class Boid {
  PVector pos, vel, acc;
  int size = 5;
  float lookRadius = 100;
  float maxSpeed = 2;
  float maxForce = 0.2;
  float safeRadius;
  color c;
  float r = 5.0;

  Boid(float x, float y) {
    pos = new PVector(x, y);
    vel = PVector.random2D();
    vel.setMag(random(2, 4));
    acc = new PVector();
    safeRadius = r * 8;
    c = color(255 - random(51));
  }

  void edges() {
    if (pos.x < 0) {
      pos.x = width;
    } else if (pos.x > width) {
      pos.x = 0;
    }
    if (pos.y < 0) {
      pos.y = height;
    } else if (pos.y > height) {
      pos.y = 0;
    }
  }
  
  void render(){
     // Draw a triangle rotated in the direction of velocity
    float theta = vel.heading() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    
    pg.fill(255);
    //pg.noFill();
    pg.stroke(255);
    pg.pushMatrix();
    pg.translate(pos.x, pos.y);
    pg.rotate(theta);
    pg.beginShape(TRIANGLES);
    pg.vertex(0, -r*2);
    pg.vertex(-r, r*2);
    pg.vertex(r, r*2);
    pg.endShape();
    pg.popMatrix();
  }

  void show() {
    pg.noStroke();
    pg.fill(c);
    pg.circle(pos.x, pos.y, size * 2);
  }

  void update() {
    vel.add(acc);
    pos.add(vel);
    acc.mult(0);
  }

  PVector align(Boid[] boids) {
    PVector steering = new PVector();
    int total = 0;
    for (Boid boid : boids) {
      float d = dist(pos.x, pos.y, boid.pos.x, boid.pos.y);
      if(boid != this && d < lookRadius){
        steering.add(boid.vel);
        total ++;
      }
    }
    if(total > 0){
      steering.div(total);
      steering.setMag(maxSpeed);
      steering.sub(vel);
      steering.limit(maxForce);
    }
    return steering;
  }

  PVector cohesion(Boid[] boids) {
    PVector steering = new PVector();
    int total = 0;
    for (Boid boid : boids) {
      float d = dist(pos.x, pos.y, boid.pos.x, boid.pos.y);
      if(boid != this && d < lookRadius){
        steering.add(boid.pos);
        total++;
      }
    }
    if(total > 0){
      steering.div(total);
      steering.sub(pos);
      steering.limit(maxForce);
    }
    return steering;
  }

  PVector seperation(Boid[] boids) {
    PVector steering = new PVector();
    int total = 0;
    for (Boid boid : boids) {
      float d = dist(pos.x, pos.y, boid.pos.x, boid.pos.y);
      if (boid != this && d < safeRadius) {
        steering.add(boid.pos);
        total++;
      }
    }
    if(total > 0){
      steering.div(total);
      steering.sub(pos);
      steering.limit(0.9);
    }

    return steering.mult(-1);
  }

  void flock(Boid[] boids) {

    PVector alignment = align(boids);
    PVector cohesion  = cohesion(boids);
    PVector seperation = seperation(boids);

    acc.add(alignment);
    acc.add(cohesion);
    acc.add(seperation);
  }
}
