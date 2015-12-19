// Class to hold our space player.
class Player extends Human {
  //Attributes
  Controller c;
  PVector angle;
  PImage body;
  float a_limit, lower_corners;
  Timer timer;
  boolean up, down, left, right, space;
  Bullet bullet;

  // Constructor
  Player(Controller c) {
    super(width/2, height/2, DEFAULT_RAD, 0, 0);
    this.c = c;
    timer = new Timer(10);
    angle = new PVector(0, -1);
    a_limit = 3;
    // Make player figure
    body = loadImage( "player.png" );
  }

  // Update player location
  
  void update() {
    //Accelerate
    if ( c.isKP('W') || c.isKP('w') ) {
      acceleration.add( angle );
      acceleration.limit(a_limit);
      velocity.add(acceleration);
    } 
    //Deaccelerate
    if (c.isKR('W') || c.isKR('w') ) {
      acceleration.mult(0);
      if (velocity.mag() < 0.1 )
        velocity.mult(0);
      velocity.mult(0.95);
    }
    
    //Accelerate
    if ( c.isKP('S') || c.isKP('s') ) {
      acceleration.add( angle.copy().rotate(PI) );
      acceleration.limit(a_limit);
      velocity.add(acceleration);
    } 
    //Deaccelerate
    if (c.isKR('S') || c.isKR('s') ) {
      acceleration.mult(0);
      if (velocity.mag() < 0.1 )
        velocity.mult(0);
      velocity.mult(0.95);
    }
    
    //Rotate left
    if (c.isKP('A') || c.isKP('a')) {
      angle.rotate(radians(5));
    }
    //Rotate right
    if (c.isKP('D') || c.isKP('d')) {
      angle.rotate(radians(-5));
    }
    // FIRE THAT bullet!
    if (c.isKP(' ') && timer.time() < 1) {
      bullet = new Bullet(location, angle);
      timer.set_to(25);
    }
    
    //Update player
    acceleration.limit(a_limit);
    velocity.add(acceleration);
    velocity.limit(HUMAN_MAX_SPEED);
    location.add(velocity);
    if (bullet != null)
      bullet.update();
  }

  // Check edges for horizontal/parallel edge loop.
  void check_edges() {
    if (location.x > width + radius)
      location.x = 0 - radius;
    if (location.x < 0 - radius)
      location.x = width + radius;
    if (location.y > height + radius)
      location.y = 0-radius;
    if (location.y < 0-radius)
      location.y = height + radius;
  }
  
  // Display player at correct location
  
  void display() {
    if (timer.time() > 0)
      timer.tick();
    pushMatrix();
    translate(location.x, location.y);
    float an = PVector.angleBetween(new PVector(0, -1), angle);
    if (angle.x < 0) {
      an = TWO_PI-an;
    }
    rotate(an);
    imageMode(CENTER);
    image(body, 0, 0, radius*2, radius*2);
    popMatrix();

    if (bullet != null)
      bullet.display();
  }
  @Override
  public void calcSteeringForces(){
    
  };
  
  // Get player's bullet object.
  Bullet get_bullet() {
    return bullet;
  }
  
  void destroy_bullet() {
    bullet = null;
  }
}