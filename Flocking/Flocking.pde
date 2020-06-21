int flockSize = 100;

Vec2 pos[] = new Vec2[flockSize];
Vec2 vel[] = new Vec2[flockSize];
Vec2 acc[] = new Vec2[flockSize];

float radius = 200;


float speedLimit = 20, targetSpeed = 20, maxForce = 10, r = 6;

void setup()
{
  size(1000, 900);
  surface.setTitle("Flocking");
  
  for(int i = 0; i < flockSize; i++)
  {
    pos[i] = new Vec2(300 + random(300), 300 + random(300));
    float radians = radians(random(360));
    float initSpeed = targetSpeed*0.01*(25 + random(50));
    vel[i] = new Vec2(initSpeed * cos(radians), initSpeed * sin(radians));
  }
  strokeWeight(2);
}

Vec2 obstacleA = new Vec2(500, 450);
float red = 0;
float green = 255;

void draw()
{
  update(1.0/frameRate);
  background(50);
  stroke(0);
  fill(0, 128, 128);
  for(int i = 0; i< flockSize; i++){
    circle(pos[i].x, pos[i].y, 2*r);
  }
  strokeWeight(3);
  stroke(50);
  fill(red, 50, );

  circle(obstacleA.x, obstacleA.y, radius);

  
  
  
  //Separation
  
}

void update(float dt){
  red = red+dt*(255 - red);
  green = green+dt*(0 - green);
  for(int i = 0; i< flockSize; i++){
    acc[i] = new Vec2(0,0);
    
    for(int j = 0; j < flockSize; j++){
      float dist = pos[i].distanceTo(pos[j]);
      if(dist < 0.01 || dist > 50){
        continue;
      }
      Vec2 separation = pos[i].minus(pos[j]).normalized();
      separation.mul(500.0/pow(dist,2));
      separation.clampToLength(10.0);
      acc[i].add(separation);
    }
    
    Vec2 avgPos = new Vec2(0,0);
    Vec2 avgVel = new Vec2(0,0);
    int count = 0;
    for(int j = 0; j < flockSize; j++){
      float dist = pos[i].distanceTo(pos[j]);
      if(dist < 50 && dist > 0){
        avgPos.add(pos[j]);
        avgVel.add(pos[j]);
        count++;
      }
    }
    if(count>0){
      avgPos.mul(1.0/count);
      Vec2 coForce = avgPos.minus(pos[i]).normalized();
      coForce.mul(4);
      coForce.clampToLength(10.0);
      acc[i].add(coForce);
      avgVel.mul(1.0/count);
      Vec2 alForce = avgVel.minus(vel[i]).normalized();
      alForce.mul(2);
      alForce.clampToLength(10.0);
      acc[i].add(alForce);
    }
    if (pos[i].distanceTo(obstacleA) < (radius+100)){ //Bouncing on the sphere
      Vec2 normal = (pos[i].minus(obstacleA)).normalized();
      Vec2 velNormal = normal.times(dot(vel[i],normal));
      velNormal.mul(10);
      velNormal.clampToLength(maxForce*10);
      vel[i].add(velNormal);
    }
 
    
  }
  //Cohesion
  
  //Alignment
  
  //Moving the particles
  for(int i = 0; i<flockSize; i++){
    pos[i].add(vel[i].times(dt));
    vel[i].add(acc[i].times(dt));
    vel[i].clampToLength(speedLimit);
    if(pos[i].y > height){
      pos[i].y = 0;
    }
    if(pos[i].y < 0){
      pos[i].y = height;
    }
    if(pos[i].x > width){
      pos[i].x = 0;
    }
    if(pos[i].x < 0){
      pos[i].x = width;
    }
    
  }
}
