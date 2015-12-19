// Default values for humans
final float HUMAN_MAX_SPEED = 2;
final float HUMAN_MAX_FORCE = 3;
final float HUMAN_RELAXED_FORCE = 0.05;
final float HUMAN_RELAXED_SPEED = 0.5;

/**
 * Represents a Human
 */
class Human extends Vehicle {
  // zombie is location of current zombie target.
  Zombie zombie = null;
  PImage body;
  //PShape body;
  PVector steeringForce;
  boolean slowed;
  float safe_distance;
  
  // Default constructor
  Human( ) {
      this( random(BORDER, width-BORDER), random(BORDER, height-BORDER), 
      DEFAULT_RAD, HUMAN_MAX_SPEED, HUMAN_MAX_FORCE);
      safe_distance = 150;
  }
  
 /**
 * @param  x     x-coordiate
 * @param  y     y-coordinate
 * @param  r     radius
 * @param  ms    max_speed
 * @param  mf    max_force
 */
  Human( float x, float y, float r, float ms, float mf) {
    // Call parent Vehicle constructor
    super( x, y, r, ms, mf );
    steeringForce = new PVector( 0, 0 );
    body = loadImage("human.png");
    safe_distance = 150;
  }
  
  //--------------------------------
  //     Abstract class methods
  //--------------------------------

  // Calculate steering forces that will affect acceleration
  void calcSteeringForces() {
    // If no zombie is following, deaccelerate and calm down.
    if ( zombie == null && slowed == true) {
      velocity.limit( HUMAN_RELAXED_SPEED );
      PVector drift = wander();
      drift.limit( HUMAN_RELAXED_FORCE );
      steeringForce.add( drift );
    }
    if ( zombie == null && slowed == false) {
      safe_distance = 150;
      steeringForce.mult(0);
      deaccelerate();
      if (velocity.mag() <= 0)
        slowed = true;
    }
    
    // Check borders
    if (location.x < BORDER) 
      steeringForce.add( right.copy().mult(max_force).add( 
          new PVector(max_force, velocity.y)) );      
    if (location.x > width - BORDER) 
      steeringForce.add( right.copy().mult(max_force).add( 
          new PVector(-max_force, velocity.y)) );     
    if (location.y < BORDER) 
      steeringForce.add( right.copy().mult(max_force).add( 
          new PVector(velocity.x, max_force)) );
    if (location.y > height - BORDER) 
      steeringForce.add( right.copy().mult(max_force).add( 
          new PVector(velocity.x, -max_force)) );

    // If a zombie is chasing you, evade!
    if ( zombie != null ) {
      safe_distance = 300;
      slowed = false;
      PVector drift = evade( zombie.location, zombie.velocity );
      steeringForce.add( drift );
    }
    
    // Limit steering forces and add drift to acceleration.
    steeringForce.limit( max_force );
    acceleration.add( steeringForce.div( mass ) );
    steeringForce.mult(0);
  }
  
  // Display human
  void display() {
    //Calculate rotation
    float angle = velocity.heading();   
    pushMatrix();
    translate( location.x, location.y );
    rotate( angle );
    imageMode(CENTER);
    image(body, 0, 0, (int)radius*2, (int)radius*2);
    
    // IF DEBUG ON
    // Draw lines
    if (debug) {
      strokeWeight(1.5);
      rotate( -angle );
      if ( zombie != null ) {
        PVector future = PVector.add( zombie.location, zombie.velocity.copy().mult(20) );
        PVector avoid_line = PVector.sub( future, location);
        stroke(#28F560);
        line(0, 0, avoid_line.x, avoid_line.y );
      }
      PVector forward_right = velocity.copy().normalize().mult(15);
      stroke(#4533F0);
      line(0, 0, forward_right.x, forward_right.y );
      line(0, 0, -forward_right.y, forward_right.x );
    }
    // END OF DEBUG
    
    popMatrix();
  }
  
  //--------------------------------
  //      Class methods
  //--------------------------------
  
  // Set zombie location to target
   void setZombie( Zombie target ) {
     zombie = target;
   }
   
   // Return current zombie target.
   Zombie zombie() {
     return zombie;
   }
   
}