// Default values for zombies
final float ZOMBIE_MAX_SPEED = 0.8;
final float ZOMBIE_MAX_FORCE = 0.9;

/**
 * Represents a Zombie
 */
class Zombie extends Vehicle {
  // human is the current human target.
  Human human = null;
  PImage body;
  PVector steeringForce;
  
  //Default constructor
  Zombie( ) {
      this( random(BORDER, width-BORDER), random(BORDER, height-BORDER), 
      DEFAULT_RAD, ZOMBIE_MAX_SPEED, ZOMBIE_MAX_FORCE);
  }
  
  //Human transformation construction
  Zombie( Human h ) {
      this( h.location.x, h.location.y, h.rad(), ZOMBIE_MAX_SPEED, ZOMBIE_MAX_FORCE);
  }
  
 /**
 * @param  x     x-coordiate
 * @param  y     y-coordinate
 * @param  r     radius
 * @param  ms    max_speed
 * @param  mf    max_force
 */
  Zombie( float x, float y, float r, float ms, float mf) {
    // Call parent Vehicle constructor
    super( x, y, r, ms, mf );
    
    steeringForce = new PVector( 0, 0 );
    body = loadImage( "zombie.png" );
  }
  
  //--------------------------------
  //Abstract class methods
  //--------------------------------
  
  // Calculate steering forces that will affect acceleration
  void calcSteeringForces() {
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
      
    // If no target:
    if ( human == null) {
      velocity.limit( HUMAN_RELAXED_SPEED );
      PVector drift = wander();
      drift.limit( HUMAN_RELAXED_FORCE );
      steeringForce.add( drift );
    }
    
    // If has human target:
    else {
      PVector drift = pursue( human.location, human.vel() );
      steeringForce.add( drift );
    }
    
    // Limit steering forces and add drift to acceleration.
    steeringForce.limit( max_force );
    acceleration.add( steeringForce.div( mass ) );
    steeringForce.mult(0);
  }
  
  // Display zombie
  void display() {
    //Calculate rotation
    float angle = velocity.heading();   

    pushMatrix();
    translate( location.x, location.y );
    rotate( angle );
    imageMode(CENTER);
    image(body, 0, 0, radius*2, radius*2);
    
    // IF DEBUG ON
    // Draw lines
    if (debug) {
      strokeWeight(1.5);
      rotate( -angle );
      if ( human != null ) {
        PVector future = PVector.add( human.location, human.velocity.copy().mult(20) );
        PVector seek_line = PVector.sub( future, location);
        stroke(#F03336);
        line(0, 0, seek_line.x, seek_line.y );
      }
      PVector forward_right = velocity.copy().normalize().mult(15);
      stroke(#4533F0);
      line(0, 0, forward_right.x, forward_right.y );
      line(0, 0, -forward_right.y, forward_right.x );
    }
    // END DEBUG 
    
    popMatrix();
  }
  
  //--------------------------------
  //      Class methods
  //--------------------------------
  
  // Set human location to target
   void setHuman( Human target ) {
     human = target;
   }
   
   // Return current human target.
   Human human() {
     return human;
   }

}