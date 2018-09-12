# Humans_vs_Zombies
Author: Martin Suarez

10/26/2015

IGME.202.03-04

Homework 3B

This programs create a field with trees, zombies, and humans.
Zombies and humans extend the Vehicle class, which in turn
implements the Obstacle interface. Trees also implement the
Obstacle interface.

The player extends the human class, and is controlled by the arrow 
keys. The player can kill humans and zombies, but loses points if
she kills the former.

A Field_Manager class creates, manages, and updates the lists
of humans, zombies, and trees, as well as checking for collisions
and transforming the humans as needed.

Since trees are generated at random locations, the TreeComparator
is used them to sort them to descending Y value to ensure the ones
at the bottom get drawn first.

To determine the number of humans, zombies, and trees, simply modify
the Field_Manager constructor.

 CONTROLS
=====================
X - Enable/Disable debug lines

Z - Add zombie to the field

H - Add human to the field     

W A S D - Move player    

Space - Shoot     

P - Respawns player       

EXTRAS
=====================
* Using a single avoid_all() method, any Vehicle can add a list of
objects (that implement the Obstacle interface) to ensure it will
avoid these objects. 
* Zombies and humans avoid interlapping with their own kind.
* Trees look better than circle
* Included a shooter player
* Useful debug commands, like respawning zombies, humans, and the player.

CREDITS
=====================
Zombie and Player images - Bombshell93 at http://www.vg-resource.com/post-493179.html

Human images - IAN HALLIWELL at http://gamedev.dmlive.co.nz/2014/04/17/