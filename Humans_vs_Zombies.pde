/*
Author: Martin Suarez

=====================
=     CONTROLS      =
=====================
= W A S D - Move    =
=         player    =
= Space - Shoot     =
=====================
=       DEBUG       =
=====================
= X - Enable/Disable=
=     debug lines.  = 
= Z - Add zombie to =
=     the field     =
= H - Add human to  =
=     the field     =
= P - Respawns      =
=      player       =
=====================

Rules:
The field starts with a predetermined number of humans, zombies, trees,
and the player (a human). The zombies actively seek the nearest human,
evading any obstacle (trees or other zombies) while the humans wander
around the forest, only running away if a zombie gets too close.

The player must shoot down the zombies and prevent other humans from
being attacked. Keep in mind that bullets and zombies cannot traverse 
trees, but the player can.

If a zombie touches the player, it's game over.

To determine the number of humans, zombies, and trees, simply modify
the Field_Manager constructor.

Latest Feature: 
* Useful debug commands, like respawning zombies, humans, and the player.

Todo:
* Score system

CREDITS:
Zombie and Player images - Bombshell93 at http://www.vg-resource.com/post-493179.html
Human images - IAN HALLIWELL at http://gamedev.dmlive.co.nz/2014/04/17/

*/

Field_Manager field;
boolean debug; // If true, lines are drawn
Controller c;
 
void setup() {
  size(1000, 1000);
  background(#6BA285); 
  // Field_Manager( # of Humans, # of Zombies, # of Trees );
  c = new Controller();
  field = new Field_Manager( 10, 10, 35, c );
}

// Controls key input
void keyPressed() {
    c.recKP(keyCode);
}

void keyReleased() {
    c.recKR(keyCode);
}

void draw() {
  background(#6BA285); 
  field.update();
  field.display();
}