//Vector Library [2D]
//CSCI 5611 Vector 2 Library [Solution]

//Instructions: Implement all of the following vector operations--

public class Vec2 {
  public float x, y;
  
  public Vec2(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  public String toString(){
    return "(" + x+ ", " + y +")";
  }
  
  public float length(){
    return sqrt(x*x +y*y);
  }
  
  public Vec2 plus(Vec2 rhs){
    return new Vec2(x+rhs.x,y+rhs.y);
  }
  
  public void add(Vec2 rhs){
    x += rhs.x;
    y += rhs.y;
  }
  
  public Vec2 minus(Vec2 rhs){
    return new Vec2(x-rhs.x,y-rhs.y);
  }
  
  public void subtract(Vec2 rhs){
    x -= rhs.x;
    y -= rhs.y;
  }
  
  public Vec2 times(float rhs){
    return new Vec2(x*rhs,y*rhs);
  }
  
  public void mul(float rhs){
    x *= rhs;
    y *= rhs;
  }
  
  public void normalize(){
    float mag = length();
    x = x/mag;
    y = y/mag;
  }
  
  public void clampToLength(float maxL){
    float magnitude = sqrt(x*x + y*y);
    if (magnitude > maxL){
      x *= maxL/magnitude;
      y *= maxL/magnitude;
    }
  }
  public Vec2 normalized(){
    return new Vec2(x/length(), y/length());
  }
  
  public float distanceTo(Vec2 rhs){
    return sqrt((rhs.x - x)*(rhs.x - x) + (rhs.y - y)*(rhs.y - y));
  }
  
}

Vec2 interpolate(Vec2 a, Vec2 b, float t){
  return new Vec2(a.x + t *(b.x - a.x), a.y + t *(b.y - a.y));
}

float interpolate(float a, float b, float t){
  return a + ((b-a)*t);
}

float dot(Vec2 a, Vec2 b){
  return a.x *b.x + a.y *b.y;
}

Vec2 projAB(Vec2 a, Vec2 b){
  return b.times(dot(a,b));
}
