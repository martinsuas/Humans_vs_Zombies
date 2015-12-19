// Default vehicle variables
final float DEFAULT_MASS = 2;
final float SD_AVOID = 10;
final float DEFAULT_RAD = 18;
final float CIRCLE_DISTANCE = 4;
final float CIRCLE_RADIUS = 0.5; // The greater, the stronger the force
final float ANGLE_CHANGE = 0.3;

/**
 * Vehicle class that implements Reynold's steering algorithms.
 */
abstract class Vehicle implements Obstacle{

  PVector location, velocity, acceleration, forward, right;
  float radius, mass, max_speed, max_force, safe_distance, wander_a;

  // Constructor - uses default mass and safe_distance
  Vehicle(float x, float y, float r, float ms, float mf) {
    this( x, y, r, ms, mf, DEFAULT_MASS, SD_AVOID );
  }
  
  // Constructor - uses default safe_distance
  Vehicle(float x, float y, float r, float ms, float mf, float m) {
    this( x, y, r, ms, mf, m, SD_AVOID );
  }
  
 /**
 * @param  x     x-coordiate
 * @param  y     y-coordinate
 * @param  r     radius
 * @param  ms    max_speed
 * @param  mf    max_force
 * @param  m     mass
 * @param  sd    safe_distance
 */
  Vehicle(float x, float y, float r, float ms, float mf, float m, float sd) {
    //Assign parameters to class fields
    location = new PVector( x, y );
    velocity = new PVector( 0, 0 );
    acceleration = new PVector( 0, 0 );
    forward = new PVector ( 0, 0 );
    right = new PVector (0, 0 );
    radius = r;
    mass = m;
    max_speed = ms;
    max_force = mf;
    safe_distance = sd;
    wander_a = 0;
  }

  //--------------------------------
  //        Abstract methods
  //--------------------------------
  abstract void calcSteeringForces();
  abstract void display();

  
  //--------------------------------
  // Acceleration Changing Methods
  //--------------------------------
  void update() {
    //calculate steering forces by calling calcSteeringForces()
    calcSteeringForces();
    //add acceleration to velocity, limit the velocity, and add velocity to position
    velocity.add( acceleration );
    velocity.limit( max_speed );
    location.add( velocity );
    //calculate forward and right vectors
    forward = velocity.copy().normalize();
    right.x = -forward.y;
    right.y = forward.x;
    
    //reset acceleration
    acceleration.mult( 0 );
  }
  
  // Avoid all obstacles in the arraylist
  void avoid_all (ArrayList<? extends Obstacle> obstacles) {
    PVector steeringForce = new PVector( 0, 0 );
    for (Obstacle o: obstacles) 
      steeringForce.add( avoid(o) );
    steeringForce.limit( max_force );
    acceleration.add( steeringForce.div( mass ) );
    steeringForce.mult(0);
  }

  // Simplifying method to add force influence's to a acceleration.
  void applyForce(PVector force) {
    acceleration.add(PVector.div(force, mass));
  }
  
  // Deaccelerates the target; if value is small sets it to zero.
  void deaccelerate() {
    if (velocity.mag() > 0.01)
      velocity.mult(0.95);
    else
      velocity.mult(0);
  }
  
  //--------------------------------
  //       Steering Methods
  //--------------------------------
  
/**
 * Seeks target in a straight line.
 * @param  target   Location of target to seek.
 */
  PVector seek (PVector target) {
    PVector desired = PVector.sub(target, location);
    desired.normalize().mult(max_speed);
    
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(max_force);
    return steer;
  }
  
/**
 * Pursue the target to its future location.
 * @param  target   Location of target to pursue.
 * @param  velocity   Velocity of target.
 */
  PVector pursue (PVector target, PVector velocity) {
    PVector future = PVector.add( target, velocity.copy().mult(20) );
    return seek( future );
  }
  
/**
 * Flees from target in a straight line.
 * @param  target   Location of target to flee from.
 */
  PVector flee (PVector target) {
    PVector desired = PVector.sub(location, target);
    desired.normalize().mult(max_speed);
    
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(max_force);
    return steer;
  }
  
/**
 * Evade the target from its future location.
 * @param  target   Location of target to evade.
 * @param  velocity   Velocity of target.
 */
  PVector evade (PVector target, PVector velocity) {
    PVector future = PVector.add( target, velocity.copy().mult(20) );
    return flee( future );
  }
  
/**
 * Make the vehicle wander
 */
  PVector wander() {
    PVector circleCenter = velocity.copy().normalize().mult(CIRCLE_DISTANCE);
    PVector displacement = new PVector( 0, -CIRCLE_RADIUS );
    float len = displacement.mag();
    displacement.x = cos( wander_a ) * len;
    displacement.y = sin( wander_a ) * len;
    wander_a += (random(1) * ANGLE_CHANGE - ANGLE_CHANGE * 0.5);
    PVector steer = circleCenter.add( displacement );
    steer.limit(max_force);
    return steer; 
  }
/**
 * Avoids target if it's in the way of vehicle's trajectory.
 * @param  obst   Obstacle to avoid.
 */
  PVector avoid (Obstacle obst) {
    PVector obst_vehicle_dist = PVector.sub( obst.loc(), location );
    float distance = obst_vehicle_dist.mag();
    safe_distance = pow(velocity.mag(), 5);
    
    //=============================
    // Non influencing conditions:=
    //=============================
    
    // Obstacle is the object itself
    if (obst == this ) {
      return new PVector( 0, 0 );
    }
    
    // Distance is further than safe_distance
    if (distance - (radius + obst.rad()) > safe_distance) {
      return new PVector( 0, 0 );
    }

    // Obstacle is behind vehicle
    if (PVector.dot(obst_vehicle_dist, forward) < 0 ) {
      return new PVector( 0, 0 );
    }
    
    // Obstacle is not in trajectory.
    if (PVector.dot(obst_vehicle_dist, right) > radius + obst.rad()) {
      return new PVector( 0, 0 );
    }
    
    //===========================
    // Obstacle is in the way.  = 
    //===========================
    PVector desired; 
    if (PVector.dot(obst_vehicle_dist, right) > 0) { // Turn left
      desired = right.copy().mult(-max_speed);
    } else { // (PVector.dot(obst_vehicle_dist, right) < 0) 
      desired = right.copy().mult(max_speed);
    }
    PVector steer = PVector.sub( desired, velocity );  
    steer.limit(max_force);
    return steer;
  }

  //--------------------------------
  //      Accessor Methods
  //--------------------------------
  
  // Interface implementations
  float rad() {
    return radius; 
  }
  PVector loc() {
    return location;
  }
  
  PVector vel() {
    return velocity;
  }
  
}