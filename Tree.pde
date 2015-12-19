// Default tree radius
final float TREE_RAD_DEF = 20;

/**
 * Tree obstacle.
 * @author Martin Suarez
 */
class Tree implements Obstacle{
  PShape trunk, head;
  float radius;
  PVector location;
  color col;
  
  // Tree default constructor
  Tree () {
    this( TREE_RAD_DEF, new PVector( random(BORDER, width-BORDER), 
              random(BORDER, height-BORDER) ) );
  }
  
 /**
 * @param  r            Tree obstacle radius
 * @param  location     Tree location
 */
  Tree( float r, PVector location ) {
    ellipseMode(RADIUS);
    head = createShape( ELLIPSE, 0, -(3*r)/2, r, r );
    head.setFill(#167110);
    head.setStroke(#699346);
    trunk = createShape(TRIANGLE, 0, -r, r/3, r/3, -r/3, r/3);
    trunk.setFill(#553D0E);
    trunk.setStroke(#898365);
    this.radius = r;
    this.location = location;
  }
  
  // Displays tree trunk 
  void display_trunk() {
    pushMatrix();
    translate( location.x, location.y );
    fill(col);
    shape( trunk );
    popMatrix();
  }
  
  // Displays head of the tree
  void display_head() {
    pushMatrix();
    translate( location.x, location.y );
    fill(col);
    shape( head );
    popMatrix();
  }
  
  // Interface implementations
  PVector loc() { return location; }
  float rad() { return radius; }
  
}