//Simulation-Driven Animation
//CSCI 5611 Example - Bouncing Balls [Exercise] - Considerably Edited by Rohan Gholkar (gholk002)
// Stephen J. Guy <sjguy@umn.edu>

//Simulation paramaters
static int maxParticles = 5000;
Vec2 spherePos = new Vec2(300,400);
float sphereRadius = 60;
float genRate = 500;
float obstacleSpeed = 200;
float COR = 0.7;
Vec2 gravity = new Vec2(0,400);
PFont font;

//Initalalize variable
Vec2 pos[] = new Vec2[maxParticles];
Vec2 vel[] = new Vec2[maxParticles];
int numParticles = 0;

void setup(){
  size(640,480);
  surface.setTitle("Fountain and Obstacle");
  font = createFont("Arial Bold", 48);
  strokeWeight(2); //Draw thicker lines 
  
}

Vec2 obstacleVel = new Vec2(0,0);

void update(float dt){
  float toGen_float = genRate * dt;
  int toGen = int(toGen_float);
  float fractPart = toGen_float - toGen;
  if (random(1) < fractPart) toGen += 1;
  for (int i = 0; i < toGen; i++){
    if (numParticles >= maxParticles) break;
    pos[numParticles] = new Vec2(width/2-10+random(20),height-random(20));
    vel[numParticles] = new Vec2(random(-50,50),-600); 
    numParticles += 1;
  }
  
  
  obstacleVel = new Vec2(0,0);
  
  if (leftPressed) 
    obstacleVel.add(new Vec2(-obstacleSpeed,0));
  if (rightPressed) 
    obstacleVel.add(new Vec2(obstacleSpeed,0));
  if (upPressed) 
    obstacleVel.add(new Vec2(0,-obstacleSpeed));
  if (downPressed) 
    obstacleVel.add(new Vec2(0,obstacleSpeed));
    
  obstacleVel.normalized().mul(obstacleSpeed);
  
  if (spacePressed) 
    obstacleVel.mul(2);
    
  spherePos.add(obstacleVel.times(dt));
  
  for (int i = 0; i <  numParticles; i++){
    
    Vec2 acc = gravity; //Gravty
    vel[i].add(acc.times(dt));
    pos[i].add(vel[i].times(dt)); //Update position based on velocity
    
    if (pos[i].y > height-2){   //Bounces off top and side walls falls through the ground
      pos[i].y = height - 2;
      vel[i].y *= -COR;
    }
    if (pos[i].y < 2){
      pos[i].y = 2;
      vel[i].y *= -COR;
    }
    if (pos[i].x > width - 2){
      pos[i].x = width - 2;
      vel[i].x *= -COR;
    }
    if (pos[i].x < 2){
      pos[i].x = 2;
      vel[i].x *= -COR;
    }
    
    if (pos[i].distanceTo(spherePos) < (sphereRadius)){ //Bouncing on the sphere
      Vec2 normal = (pos[i].minus(spherePos)).normalized();
      pos[i] = spherePos.plus(normal.times(sphereRadius).times(1.01));
      Vec2 velNormal = normal.times(dot(vel[i],normal));
      vel[i].subtract(velNormal.times(1 + COR));
      vel[i].add(projAB(obstacleVel,normal));
    }
  }
  
}

boolean leftPressed, rightPressed, upPressed, downPressed, spacePressed;
void keyPressed(){
  if (keyCode == LEFT) leftPressed = true;
  if (keyCode == RIGHT) rightPressed = true;
  if (keyCode == UP) upPressed = true; 
  if (keyCode == DOWN) downPressed = true;
  if (keyCode == ' ') spacePressed = true;
}

void keyReleased(){
  if (key == 'r'){
    println("Reseting the System");
    pos = new Vec2[maxParticles];
    vel = new Vec2[maxParticles];
    numParticles = 0;
  }
  if (keyCode == LEFT) leftPressed = false;
  if (keyCode == RIGHT) rightPressed = false;
  if (keyCode == UP) upPressed = false; 
  if (keyCode == DOWN) downPressed = false;
  if (keyCode == ' ') spacePressed = false;
}


void draw(){
  update(1.0/frameRate);

  //173, 216, 230
  background(50); //White background
  textFont(font, 18);
  fill(255);
  stroke(255);
  text("FPS", 0, 20);
  text(int(frameRate), 40, 20);
  strokeCap(ROUND);
  stroke(153, 176, 255);
  strokeWeight(2);
  for (int i = 0; i < numParticles; i++){
    point(pos[i].x, pos[i].y); //(x, y, diameter)
  }
  strokeWeight(0);
  fill(255,99,71);
  circle(spherePos.x, spherePos.y, sphereRadius*2); //(x, y, diameter)
}






// Begin the Vec2 Libraray

//Vector Library
//CSCI 5611 Vector 2 Library [Example]
// Stephen J. Guy <sjguy@umn.edu>

public class Vec2 {
  public float x, y;
  
  public Vec2(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  public String toString(){
    return "(" + x+ "," + y +")";
  }
  
  public float length(){
    return sqrt(x*x+y*y);
  }
  
  public Vec2 plus(Vec2 rhs){
    return new Vec2(x+rhs.x, y+rhs.y);
  }
  
  public void add(Vec2 rhs){
    x += rhs.x;
    y += rhs.y;
  }
  
  public Vec2 minus(Vec2 rhs){
    return new Vec2(x-rhs.x, y-rhs.y);
  }
  
  public void subtract(Vec2 rhs){
    x -= rhs.x;
    y -= rhs.y;
  }
  
  public Vec2 times(float rhs){
    return new Vec2(x*rhs, y*rhs);
  }
  
  public void mul(float rhs){
    x *= rhs;
    y *= rhs;
  }
  
  public void clampToLength(float maxL){
    float magnitude = sqrt(x*x + y*y);
    if (magnitude > maxL){
      x *= maxL/magnitude;
      y *= maxL/magnitude;
    }
  }
  
  public void setToLength(float newL){
    float magnitude = sqrt(x*x + y*y);
    x *= newL/magnitude;
    y *= newL/magnitude;
  }
  
  public void normalize(){
    float magnitude = sqrt(x*x + y*y);
    x /= magnitude;
    y /= magnitude;
  }
  
  public Vec2 normalized(){
    float magnitude = sqrt(x*x + y*y);
    return new Vec2(x/magnitude, y/magnitude);
  }
  
  public float distanceTo(Vec2 rhs){
    float dx = rhs.x - x;
    float dy = rhs.y - y;
    return sqrt(dx*dx + dy*dy);
  }
}

Vec2 interpolate(Vec2 a, Vec2 b, float t){
  return a.plus((b.minus(a)).times(t));
}

float interpolate(float a, float b, float t){
  return a + ((b-a)*t);
}

float dot(Vec2 a, Vec2 b){
  return a.x*b.x + a.y*b.y;
}

Vec2 projAB(Vec2 a, Vec2 b){
  return b.times(a.x*b.x + a.y*b.y);
}

void delete(Vec2[] pos, int item){
    Vec2[] tempPos = new Vec2[pos.length - 1];
    pos[item] = pos[0];
    for(int j = 0; j< tempPos.length; j++){
      tempPos[j] = pos[j+1];
    }
    pos = tempPos;
}
