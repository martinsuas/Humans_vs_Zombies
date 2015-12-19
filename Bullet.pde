
// Class to represent a missile.
class Bullet {
  PVector location, velocity, angle;
  PShape missile;
  
  //Constructor
  Bullet( PVector location, PVector angle) {
    this.location = location.copy();
    this.angle = angle.copy();
    this.velocity = angle.copy();
    velocity.mult(15);
    rectMode(CORNER);
    fill(#FF4346);
    missile = createShape(RECT, -3, 0, 3, 3);
  }
  
  // Move the missile
  void update() {
    location.add(velocity);
  }
  
  // Calculate angle and draw accordingly
  void display() {
    float an = PVector.angleBetween(new PVector(0,-1), angle);
     if (angle.x < 0) {
       an = TWO_PI-an;
     }
    pushMatrix();
    translate(location.x, location.y);
    rotate( an );
    shape(missile);
    popMatrix();
  }
  
  // Get location of missile
  PVector get_loc() {
    return location;
  }
  
}