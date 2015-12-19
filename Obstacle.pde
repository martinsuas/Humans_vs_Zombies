// All obstacles must implement loc() and rad() to determine
// collisions.
interface Obstacle {
  // Return obstacle location
  PVector loc();
  // Return obstacle radius
  float rad();
}