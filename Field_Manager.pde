import java.util.Comparator;
import java.util.Collections;
final float BORDER = 75;

/**
 * Field Manager creates, updates, and displays the lists
 * of zombies, humans, and trees. It checks for collisions
 * and deals with humans becoming zombies.
 * @author Martin Suarez
 */
class Field_Manager {
  ArrayList<Human> humans;
  ArrayList<Zombie> zombies;
  ArrayList<Tree> trees;
  Player player;
  Controller c;
  Timer timer;
  int score;
  
  boolean game_over; // True if hit
  
 /**
 * @param  humans      Initial number of humans
 * @param  zombies     Initial number of zombies
 * @param  trees       Initial number of trees
 */
  Field_Manager( int humans, int zombies, int trees, Controller c ) {
    this.c = c;
    player = new Player( c );
    this.humans = new ArrayList<Human>(humans);
    this.zombies = new ArrayList<Zombie>(humans+zombies+1);
    this.trees = new ArrayList<Tree>(trees);
    for (int i = 0; i < humans; i++)
      this.humans.add( new Human() );
    for (int i = 0; i < zombies; i++)
      this.zombies.add( new Zombie() );
    for (int i = 0; i < trees; i++)
      this.trees.add( new Tree() );
    this.humans.add( player );
      
    // Sort trees
    Collections.sort(this.trees, new TreeComparator());
    timer = new Timer(0);
    game_over = false;
    score = 0;
  }
  
  // Updates targets and checks for collisions
  void update() {
    // Default human and zombie's target to null
    for (Human h : humans) {
      h.setZombie(null);
    }
    for (Zombie z : zombies) {
      z.setHuman(null);
    }
    
    // For every combination of human-zombie
    for ( int h = 0; h < humans.size(); h++ ) {
      for ( int z = 0; z < zombies.size(); z++ ) {
        // Calculate distance between zombie and human
        float d = humans.get(h).loc().dist( zombies.get(z).loc()  );
        
        // Update human if closer to SAFE_DISTANCE and no zombie yet
        if (humans.get(h).zombie == null && d < humans.get(h).safe_distance)
          humans.get(h).setZombie( zombies.get(z) );
        
        // Update human if this distance is smaller than current target
        else if ( humans.get(h).zombie != null &&
        humans.get(h).zombie.location.dist( humans.get(h).location ) > d )
          humans.get(h).setZombie( zombies.get(z) );
          
        // Update zombie if no human as target
        if (zombies.get(z).human() == null)
          zombies.get(z).setHuman( humans.get(h) );
        // Update zombie if closer human target
        else if (zombies.get(z).human().loc().dist( zombies.get(z).loc() ) > d )
          zombies.get(z).setHuman( humans.get(h) );
          
        // Check for collisions
        if (d < humans.get(h).rad() + zombies.get(z).rad() ) {
          zombies.add( new Zombie ( humans.get(h) ) );
          if (player != null && humans.get(h).getClass() == player.getClass()) {
            player = null;
          }
          humans.remove( h );
          h--;
          score -= 25;
          break;
        }
        // Collision detection asteroid-missile
      if (player != null && player.get_bullet() != null && timer.time() < 1 &&
         (player.get_bullet().get_loc().dist(zombies.get(z).location) 
                         < zombies.get(z).radius )) {
           zombies.remove(z);
           z--;
           timer.set_to(20);
           score += 100;
           player.destroy_bullet();
           break;
        }
        
        if (player != null && player.get_bullet() != null && timer.time() < 1 &&
         (player.get_bullet().get_loc().dist(humans.get(h).location) 
              < humans.get(h).radius && humans.get(h).getClass() != player.getClass()  )) {
           humans.remove(h);
           h--;
           timer.set_to(20);
           score -= 100;
           player.destroy_bullet();
           break;
        }
      }
    } // End of for
  }
  
  // Updates each zombie/human and displays them. 
  void display() {
    
    // Timer helps decrease sensibility of pressing a button
    if (timer.time > 0)
      timer.tick();
    
    for (Human h : humans) {
      h.avoid_all(trees);
      h.avoid_all(humans);
      h.update();
      h.display();
    }
    
    for (Zombie z : zombies) {
      z.avoid_all(trees);
      z.avoid_all(zombies);
      z.update();
      z.display();
    }
    
    // Trunks drawn separately to ensure no trunk is drawn in top of a head.
    for (Tree t : trees) {
      t.display_trunk();
    }
    
    for (Tree t : trees) {
      // Check for tree bullet collisions
       if (player != null && player.get_bullet() != null && timer.time() < 1 &&
         (player.get_bullet().get_loc().dist(t.location) < t.radius )) {
           timer.set_to(20);
           player.destroy_bullet();
        }
      t.display_head();
    }
    // Check for player's edges
    if (player != null)
      player.check_edges();
    
    // Check for control keys
    // Set debugging on/off
    if ((keyPressed == true) && ((key == 'X')||(key == 'x') ) && timer.time < 1) {
      debug = !debug;
      timer.set_to(20);
    }
    // Add a zombie
    if ((keyPressed == true) && ((key == 'Z')||(key == 'z') ) && timer.time < 1) {
      zombies.add( new Zombie() );
      timer.set_to(3); 
    }
    // Add a human
    if ((keyPressed == true) && ((key == 'H')||(key == 'h') ) && timer.time < 1) {
      humans.add( new Human() );
      timer.set_to(3);
    }
    
    if ((keyPressed == true) && ((key == 'P')||(key == 'p') ) && timer.time < 1 
          && player == null ) {
      player = new Player( c );
      humans.add( player );
      timer.set_to(3);
    }
    
    // Draws score
    textSize(32);
    fill(255);
    textAlign(CENTER);
    text( "Score: " + str(score), width/2, height/16 );
    
    // if you win
    if (zombies.size() == 0) {
      textSize(45);
      text( "You win!", width/2, height/2);
    }
  }

}